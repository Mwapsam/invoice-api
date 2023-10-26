class ChangeColumnTypeOnOrders < ActiveRecord::Migration[7.0]
  def up
    add_column :orders, :new_invoice_id, :uuid
    Order.reset_column_information

    Order.find_each do |order|
      order.update(new_invoice_id: order.invoice_id)
    end

    remove_column :orders, :invoice_id
    rename_column :orders, :new_invoice_id, :invoice_id
  end

  def down
    # Add code to revert the changes made in the up method
    add_column :orders, :new_invoice_id, :integer
    Order.reset_column_information
  
    Order.find_each do |order|
      order.update(new_new_invoice_id: order.invoice_id)
    end
  
    remove_column :orders, :invoice_id
    rename_column :orders, :new_invoice_id, :invoice_id
  end
end
