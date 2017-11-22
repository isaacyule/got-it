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
    @request = Request.where(product: @product, user: current_user).first
    @review = Review.new(review_params)
    @review.request = @request
    @review.user = current_user
    authorize(@review)
    if @review.save
      respond_to do |format|
        format.html { redirect_to product_path(@product) }
        format.js  # <-- will render `app/views/reviews/create.js.erb`
      end
    else
      respond_to do |format|
        format.html { render 'products/show' }
        format.js  # <-- idem
      end
    end
  end


  private

  def review_params
    params.require(:review).permit(:content)
  end
end
