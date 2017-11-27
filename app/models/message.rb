class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  after_create :broadcast_message

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
end

