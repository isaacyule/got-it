class ReviewsController < ApplicationController

  def create
    @product = Product.find(params[:product_id])
    @request = Request.where(product: @product, user: current_user).first
    @review = Review.new(review_params)
    @review.request = @request
    @review.user = current_user
    if @review.save
      redirect_to product_path(@product)
    else
      render 'product/show'
    end
  end

  private

  def review_params
    params.require(:review).permit(:content)
  end
end
