class ReviewsController < ApplicationController
  before_action :review_params, only: [:create]

  def create
    @product = Product.find(params[:product_id])
    @request = Request.where(product: @product, user: current_user).first
    @review = Review.new(review_params)
    @review.user = current_user
    @review.request = @request
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
