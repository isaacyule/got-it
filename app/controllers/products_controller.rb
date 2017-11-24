class ProductsController < ApplicationController
  protect_from_forgery
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  def index
    @products = policy_scope(Product)
  end

  def show
    set_rating
    @request = Request.new
    @request.product = @product
    authorize(@product)
    if (@product.latitude? && @product.longitude?)
      @hash = Gmaps4rails.build_markers(@product) do |product, marker|
        marker.lat product.latitude
        marker.lng product.longitude
      end
    end
  end

  def new
    @product = Product.new
    authorize(@product)
  end

  def create
    @product = Product.new(product_params)
    @product.user_id = current_user.id
    authorize(@product)
    if @product.save
      if @product.photo?
        Cloudinary::Uploader.upload(params["product"]["photo"])
      end
      redirect_to product_path(@product)

    else
      render :new
    end
  end

  def edit
    authorize(@product)
  end

  def update
    authorize(@product)
    if @product.save
      if @product.photo?
        Cloudinary::Uploader.upload(params["product"]["photo"])
      end
      redirect_to product_path(@product)

    else
      render :edit
    end
  end

  def destroy
    authorize(@product)
    @product.destroy
    redirect_to products_path
  end


  private

  def set_product
    @product = Product.find(params[:id])
  end


  def product_params
    params.require(:product).permit(:name, :description, :price_per_day, :condition, :deposit, :handover_fee, :photo, :address)
  end

  def set_rating
    p_counter = 0
    @product.reviews.each { |review| p_counter += review.overall }
    rating = p_counter.to_f / @product.reviews.count.to_f
    @product.rating = rating.round(2)
  end
end
