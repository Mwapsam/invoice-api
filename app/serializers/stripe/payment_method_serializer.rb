class Stripe::PaymentMethodSerializer < ActiveModel::Serializer
  attributes :id, :object, :billing_details, :card, :created, :customer, :livemode, :metadata, :type
end
