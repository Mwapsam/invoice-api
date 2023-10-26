class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :description, :due_date, :send_immediately, :allow_partial_payments, :delivery_mode, :customer_id, :created_at, :updated_at, :total_entries, :line_items

  has_one :order
  belongs_to :customer

  def line_items
    if object.order.present?
      object.order.line_items
    else
      []
    end
  end
end
