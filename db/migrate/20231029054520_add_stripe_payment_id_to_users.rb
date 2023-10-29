class AddStripePaymentIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :stripe_payment_id, :string
    add_index :users, :stripe_payment_id, unique: true
  end
end
