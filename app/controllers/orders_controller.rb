class OrdersController < ApplicationController
  def show
    @order = Order.where(state: 'paid').find(params[:id])
    authorize(@order)
  end

  def create
    product = Product.find(params[:product_id])
    order  = Order.create!(amount: product.total, state: 'pending', user: current_user, product: product)
    authorize(order)
    redirect_to new_order_payment_path(order)
  end
end
