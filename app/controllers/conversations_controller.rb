class ConversationsController < ApplicationController
 before_action :authenticate_user!

  def index
   @conversations= policy_scope(Conversation)
   @users = User.all
   @conversations = Conversation.all.where(:sender_id == :recipient_id)
   end

  def create
   if Conversation.between(params[:sender_id],params[:recipient_id])
     .present?
      @conversation = Conversation.between(params[:sender_id],
       params[:recipient_id]).first
   else
    @conversation = Conversation.create(conversation_params)
   end
   authorize(@conversation)
   redirect_to conversation_messages_path(@conversation)
  end

  private
   def conversation_params
    params.permit(:sender_id, :recipient_id, :request_id)
   end
end
