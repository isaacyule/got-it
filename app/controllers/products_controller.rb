class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.user_id = current_user.id
    if @product.save
      if @product.photo?
        Cloudinary::Uploader.upload(params["product"]["photo"])
      # else
      #   @product.photo = "https://static.pexels.com/photos/316466/pexels-photo-316466.jpeg"
      end
      redirect_to product_path(@product)

    else
      render :new
    end
  end

  def edit
  end

  def update
    @product.update(product_params)

    redirect_to product_path(@product)
  end

  def destroy
    @product.destroy
    redirect_to products_path
  end

  private


  def set_product
    @product = Product.find(params[:id])
  end



  def product_params
    params.require(:product).permit(:name, :description, :price_per_day, :deposit, :minimum_fee, :photo)
  end
end
