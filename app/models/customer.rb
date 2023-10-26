class Customer < ApplicationRecord
  has_many :invoices, dependent: :destroy
  belongs_to :user

  before_create :issue_merchant_id
  
  after_create do
    if stripe_customer_id.blank?
      full_name = first_name + ' ' + last_name
      address = {
        line1: address1,
        city: city,
        postal_code: postal_code,
        state: state,
        country: country
      }
      shipping = {
        address: address,
        name: full_name,
        phone: phone_number
      }
      customer = Stripe::Customer.create(name: full_name, email: email, address: address, phone: phone_number, shipping: shipping)      
      update(stripe_customer_id: customer.id)
    end
  end

  def issue_merchant_id
    self.merchant_customer_id = SecureRandom.uuid
  end

  def update_payment_method(payment_method_id)
    if stripe_customer_id.blank?
      return false
    end
  
    begin
      customer = Stripe::Customer.update(
        stripe_customer_id, 
        invoice_settings: { default_payment_method: payment_method_id }
      )
  
      self.payment_method = customer.invoice_settings.default_payment_method
      save!
  
      return customer
    rescue Stripe::StripeError => e
      errors.add(:base, "Error updating payment method: #{e.message}")
      return false
    end
  end  
end
