class ReviewsController < ApplicationController
  protect_from_forgery
  before_action :review_params, only: [:create]

  def new
    @product = Product.find(params[:product_id])
    @request = Request.where(product: @product, user: current_user).first
    @review = Review.new
    @review.request = @request
    @review.user = current_user
    authorize(@review)
  end

  def create
    @product = Product.find(params[:product_id])
    @request = Request.where(product: @product, user: current_user).last
    @review = Review.new(review_params)
    @review.request = @request
    @review.user = current_user
    authorize(@review)
    if @review.save
      redirect_to product_path(@product)
      return
    else
      render :new
    end
  end


  private

  def review_params
    params.require(:review).permit(:content, :overall)
  end
end
