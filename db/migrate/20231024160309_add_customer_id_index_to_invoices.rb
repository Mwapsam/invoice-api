class AddCustomerIdIndexToInvoices < ActiveRecord::Migration[7.0]
  def change
    add_index :invoices, :customer_id
  end
end
