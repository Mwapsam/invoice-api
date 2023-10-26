class Payment < ApplicationRecord
  belongs_to :invoice
  belongs_to :customer, dependent: :destroy

  def handle_payment_method(payment_method)
    self.customer.update_payment_method(payment_method)
  end
end
