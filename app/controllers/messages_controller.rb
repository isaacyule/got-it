class MessagesController < ApplicationController
  before_action do
   @conversation = Conversation.find(params[:conversation_id])
  end

  def index
    @messages = policy_scope(Message)
    @messages = @conversation.messages.order(:created_at)
    if @conversation.messages.last.user_id != current_user.id
      last_message = @conversation.messages.last
      set_message_to_read(last_message)
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
    if @conversation.messages[-2].read == true
      @message.notify :users, key: @message.conversation.id
    end
  end

private

  def message_params
    params.require(:message).permit(:body, :user_id)
  end

  def set_message_to_read(message)
    message.read = true
    message.save
  end
end

