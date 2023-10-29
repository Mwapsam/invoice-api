class Payment < ApplicationRecord
  belongs_to :invoice
  belongs_to :customer, dependent: :destroy

  def handle_payment_method(payment_method)
    customer.update_payment_method(payment_method)
  end
end
