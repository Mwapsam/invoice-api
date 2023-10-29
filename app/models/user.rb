class User < ApplicationRecord
  has_many :customers, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :audit_logs, dependent: :destroy
  has_many :invoices, through: :customers
  has_one :person, dependent: :destroy
  has_many :line_items, through: :orders

  validates :phone_number, presence: true, uniqueness: { case_sensitive: true }
  validates :account_balance, presence: true, numericality: { greater_than_or_equal_to: 0 }

  has_secure_password

  after_create do
    customer = Stripe::Customer.create(phone: phone_number)
    update(stripe_customer_id: customer.id)
  end

  def update_balance(amount, _currency)
    Stripe::Customer.update(
      stripe_customer_id,
      balance: account_balance + amount
    )
    self.account_balance += amount
    save
  end

  def create_payment_method(payment_method_id)
    return false if stripe_customer_id.blank?

    begin
      source = Stripe::PaymentMethod.attach(
        payment_method_id,
        customer: stripe_customer_id
      )

      update(stripe_payment_id: source.id)

      { success: true, message: 'Payment method created successfully' }
    rescue Stripe::StripeError => e
      { success: false, error: e.message }
    rescue StandardError
      { success: false, error: 'An unexpected error occurred' }
    end
  end

  def customer_payment_methods
    return nil if stripe_customer_id.blank?

    begin
      payment_methods = Stripe::Customer.list_payment_methods(
        stripe_customer_id,
        { type: 'card' }
      )

      payment_methods.data
    rescue Stripe::StripeError => e
      Rails.logger.error("Stripe API error: #{e.message}")
      { success: false, error: e.message }
    rescue StandardError
      { success: false, error: 'An unexpected error occurred' }
    end
  end

  def approve_kyc
    return false unless kyc_status == 'pending'

    update(kyc_status: 'approved')
    true
  end
end
