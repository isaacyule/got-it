class ReviewsController < ApplicationController
  before_action :review_params, only: [:create]

  def create
    @product = Product.find(params[:product_id])
<<<<<<< HEAD
    @request = Request.where(product: @product, user: current_user).first
    @review = Review.new(review_params)
    @review.user = current_user
    @review.request = @request
=======
    @request = Request.where(product: @product, user: current_user, status: "Accepted").first
    @review = Review.new(review_params)
    @review.request = @request
    @review.user = current_user
>>>>>>> a7946678d18b282812da8896fd611327770ccaa2
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
