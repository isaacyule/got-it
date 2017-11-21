class RequestsController < ApplicationController
  protect_from_forgery
  before_action :set_product, only: [:new, :create]

  def new
    @request = Request.new
    @request.product = @product
    authorize(@request)
    @dates = []
    @product.requests.where(status: 'Accepted').each do |request|
      (Date.parse(request.start_date[0, 10])..Date.parse(request.end_date[0, 10])).each do |d|
        @dates << d
      end
    end
  end

  def create
    @request = Request.new(request_params)
    @request.user = User.find(current_user.id)
    @request.product = Product.find(params[:product_id])
    authorize(@request)
    if @request.save
      redirect_to product_path(@product)
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
    @request.update(status: params[:status])
    authorize(@request)
    redirect_to user_path
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
