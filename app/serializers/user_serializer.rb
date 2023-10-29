class UserSerializer < ActiveModel::Serializer
  attributes :id, :phone_number, :role, :approved, :account_balance, :kyc_status, :created_at, :stripe_customer_id
end
