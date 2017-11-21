json.array!(@product.requests.where(status: 'Accepted')) do |booking|
  json.extract! booking, :user_id, :product_id, :description, :status
  json.start booking.start_date
  json.end booking.end_date
  json.url product_url(booking, format: :html)
  json.title booking.user.email
end
