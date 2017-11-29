class PaymentsController < ApplicationController
  before_action :set_order

  def new
    authorize(@order)
  end

  def create
    customer = Stripe::Customer.create(
      source: params[:stripeToken],
      email:  params[:stripeEmail]
    )

    charge = Stripe::Charge.create(
      customer:     customer.id,   # You should store this customer id and re-use it.
      amount:       @order.amount_pennies,
      description:  "Payment for product #{@order.product_sku} for order #{@order.id}",
      currency:     @order.amount.currency
    )

    @order.update(payment: charge.to_json, state: 'paid')
    authorize(@order)
    @product = Product.find(Order.find(params["order_id"].to_i)["product_id"])
    redirect_to product_path(@product)

  rescue Stripe::CardError => e
    flash[:alert] = e.message
    redirect_to new_order_payment_path(@orders)
  end

private

  def set_order
    @order = Order.where(state: 'pending').find(params[:order_id])
  end
end

