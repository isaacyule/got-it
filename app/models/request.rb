  class Request < ApplicationRecord
  belongs_to :user
  belongs_to :product

  has_one :review
  has_one :ureview
  has_one :conversation, dependent: :destroy

  validates :user_id, :product_id, :start_date, :end_date, presence: true
  # validates_uniqueness_of :product_id, { scope: :user,
  #   message: "already requested" }

  acts_as_notifiable :users, targets: -> (request, key) {
    [request.set_notification_target]
  }, notifiable_path: :request_notifiable_path


  def request_notifiable_path
    conversation_messages_path(self.conversation)
  end

  def set_notification_target
    if self.status == "Pending"
      return self.product.user
    else
      return self.user
    end
  end
end
