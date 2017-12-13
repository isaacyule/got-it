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
    end
    unless @conversation.messages[-2].user == current_user && Time.now - @conversation.messages[-2].created_at < 300
      @message.notify :users, key: @message.conversation.id
    end
  end

private
 def message_params
  params.require(:message).permit(:body, :user_id)
 end
end

