class ReviewsController < ApplicationController
  protect_from_forgery
  before_action :review_params, only: [:create]

  def create
    @product = Product.find(params[:product_id])
    @request = Request.where(product: @product, user: current_user).first
    @review = Review.new(review_params)
    @review.request = @request
    @review.user = current_user
    authorize(@review)
    if @review.save
      redirect_to product_path(@product)
    else
      render 'products/show'
    end
  end

  private

  def review_params
    params.require(:review).permit(:content)
  end
end
