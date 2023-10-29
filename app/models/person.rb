class Person < ApplicationRecord
  belongs_to :user

  has_one_attached :card_front
  has_one_attached :card_back

  after_create do
    Stripe::Customer.update(
      user.stripe_customer_id,
      name: "#{first_name} #{last_name}",
      email:,
      address: {
        city:,
        country: kyc_country,
        line1: address_line_1,
        line2: address_line_2,
        postal_code:,
        state:
      }
    )
  end

  def identity_card
    identity_cards.map do |identity_card|
      Rails.application.routes.url_helpers.rails_blob_path(identity_card, only_path: true)
    end
  end
end
