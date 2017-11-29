class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  after_create :broadcast_message

  acts_as_notifiable :users, targets: -> (message, key) {
    [message.conversation.recipient, message.conversation.sender] - [message.user]
  }, notifiable_path: :message_notifiable_path

 validates_presence_of :body, :conversation_id, :user_id

 def message_time
  created_at.strftime("%m/%d/%y at %l:%M %p")
 end

 private

 def broadcast_message
    ActionCable.server.broadcast("conversation_channel_#{self.conversation.id}", {
      message_partial: ApplicationController.renderer.render(
        partial: "messages/message",
        locals: { message: self, user_is_author: false }
      ),
      current_user_id: user.id
    })
 end

 def message_notifiable_path
   conversation_messages_path(self.conversation)
 end
end

