class Conversation < ActiveRecord::Base
  belongs_to :sender, :foreign_key => :sender_id, class_name: "User"
  belongs_to :recipient, :foreign_key => :recipient_id, class_name: "User"
  belongs_to :request

  has_many :messages, dependent: :destroy
  validates_uniqueness_of :sender_id, :scope => :recipient_id
  scope :between, -> (sender, recipient, request) do
    where("(conversations.sender_id = ? AND conversations.recipient_id = ? AND conversations.request_id = ?) OR (conversations.sender_id = ? AND conversations.recipient_id = ? AND conversations.request_id = ?)", sender.id, recipient.id, request.id, recipient.id, sender.id, request.id)
  end
end
