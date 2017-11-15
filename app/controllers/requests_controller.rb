class RequestsController < ApplicationController
  protect_from_forgery
  before_action :set_product, only: [:new, :create]

  def new
    @request = Request.new
  end

  def create
    @request = Request.new(request_params)
    @request.user = User.find(current_user.id)
    @request.product = Product.find(params[:product_id])
    if @request.save
      redirect_to product_path(@product)
    else
      render :new
    end
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
