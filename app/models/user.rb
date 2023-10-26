class User < ApplicationRecord
  has_many :customers, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :audit_logs, dependent: :destroy
  has_many :invoices, through: :customers

  validates :phone_number, presence: true, uniqueness: { case_sensitive: true }
  validates :account_balance, presence: true, numericality: { greater_than_or_equal_to: 0 }

  has_secure_password

  after_create do
    customer = Stripe::Customer.create(phone: phone_number)
    update(stripe_customer_id: customer.id)
  end

  def update_balance(amount, currency)
    Stripe::Customer.update(
      stripe_customer_id, 
      balance: account_balance + amount
    )
    self.account_balance += amount
    save
  end
end
