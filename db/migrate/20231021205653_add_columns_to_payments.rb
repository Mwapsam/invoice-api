class AddColumnsToPayments < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :transaction_id, :string
    add_column :payments, :amount, :integer
    add_column :payments, :currency, :string
    add_column :payments, :status, :string
  end
end
