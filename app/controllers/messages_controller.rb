class MessagesController < ApplicationController
  before_action do
   @conversation = Conversation.find(params[:conversation_id])
  end

  def index
   @messages = policy_scope(Message)
   @messages = @conversation.messages.order(:created_at)
   if @messages.last
    if @messages.last.user_id != current_user.id
     @messages.last.read = true;
    end
   end
    @message = Message.new
   end

  def new
   authorize(@message)
   @message = @conversation.messages.new
  end

  def create
   @message = @conversation.messages.new(message_params)
   authorize(@message)
   if @message.save
    respond_to do |format|
      format.js
    end
    @message.notify :users, key: "message.body"
   end
  end

private
 def message_params
  params.require(:message).permit(:body, :user_id)
 end
end

