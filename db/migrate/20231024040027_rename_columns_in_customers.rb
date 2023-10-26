class RenameColumnsInCustomers < ActiveRecord::Migration[7.0]
  def change
    rename_column :customers, :locality, :city
    rename_column :customers, :administrative_area, :state
    add_index :customers, :stripe_customer_id
    add_index :customers, :email
  end
end
