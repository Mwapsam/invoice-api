class ChangeCustomerIdToString < ActiveRecord::Migration[7.0]
  def change
    change_column :invoices, :customer_id, :string
  end
end
