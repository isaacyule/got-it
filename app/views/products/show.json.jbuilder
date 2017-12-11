json.array!(@product.requests.where(status: 'Accepted')) do |product_request|
  json.extract! product_request, :user_id, :product_id, :description, :status
  json.start product_request.start_date
  json.end product_request.end_date
  json.url "/conversations/" + product_request.conversation.id.to_s + "/messages"
  json.title product_request.product.name
end
