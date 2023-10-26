class AddPaymentMethodToCustomers < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :payment_method, :string
  end
end
