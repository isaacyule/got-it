class ProductsController < ApplicationController
  before_action :set_product only: [:index, :show, :create, :edit, :destroy]

  def index

  end

  def show

  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to user_product_index_path(user)
    else
      render :new
    end
  end

  def edit
  end

  def update
    @product.update(product_params)

    redirect_to user_product_index_path(user)
  end

  def destroy
    @product.destroy

    redirect_to user_product_index_path(user)
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(product).permit(:name, :description, :price_per_day, :deposit, :minimum_fee)
  end
end
