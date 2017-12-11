class RequestsController < ApplicationController
  protect_from_forgery
  before_action :set_product, only: [:new, :create]

  def new
    match_data = params[:daterange].match(/([\d\-]+) - ([\d\-]+)/)
    @request = Request.new(start_date: Date.parse(match_data[1]), end_date: Date.parse(match_data[2]))
    @request.product = @product
    authorize(@request)

    @dates = []
    @product.requests.where(status: 'Accepted').each do |request|
      (request.start_date..request.end_date).each do |d|
        @dates << d
      end
    end
  end

  def create
    @request = Request.new(request_params)
    @request.user = current_user
    @request.product = Product.find(params[:product_id])
    authorize(@request)

    if @request.save
      if Conversation.between(current_user, @request.product.user, @request).present?
        @conversation = Conversation.between(current_user, @request.product.user, @request).last
      else
        @conversation = Conversation.create(sender: current_user, recipient: @request.product.user, request: @request)
      end
      @conversation.messages.create(body: @request.description, user: current_user, read: false)
      # redirect_to product_path(@product)
      # redirect_to  new_order_payment_path(@product.order.id)
      order  = Order.create!(amount: params[:total_price].to_f, state: 'pending', user: current_user, product: @request.product)
      authorize(order)
      redirect_to new_order_payment_path(order, request: @request, product: @request.product)
      # ActivityNotification::Notification.notify :users, @request, key: "request.description"
      @request.notify :users, key: @conversation.id

    else
      render :new
    end
  end

  def index
    @requests = policy_scope(Request)
    @allrequests = current_user.requests
  end

  def update
    @request = Request.find(params[:id])
    @conversation = Conversation.where(request: @request).first
    @request.update(status: params[:status])
    @message = @conversation.messages.create(body: "This request has been accepted", user: current_user, read: false)
    @message.save
    @message.notify :users, key: @message.conversation.id
    authorize(@request)
    redirect_to root_path
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
    @owner = @product.user
  end

  def request_params
    params.require(:request).permit(:description, :start_date, :end_date)
  end
end
