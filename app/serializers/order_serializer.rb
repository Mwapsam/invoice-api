class OrderSerializer < ActiveModel::Serializer
  attributes :id, :amount_details, :invoice_id, :payment_status

  def amount_details
    object.amount_details
  end

  has_many :line_items
end
