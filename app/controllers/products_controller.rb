class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  def index
    @products = policy_scope(Product)

    if params['search'].nil?
      @products = Product.all
    else
      search = params['search']
      @products = Product.where("name iLIKE ?", "%#{search}%")
    end
  end

  def show
    @request = Request.new
    @request.product = @product
    authorize(@product)
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
    if @product.update(product_params)
      redirect_to @product, notice: "Product was successfully updates."
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
    params.require(:product).permit(:name, :description, :price_per_day, :deposit, :minimum_fee, :photo)
  end
end
