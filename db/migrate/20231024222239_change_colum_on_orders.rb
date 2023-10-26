class ChangeColumOnOrders < ActiveRecord::Migration[7.0]
  def up
    add_column :line_items, :new_order_id, :uuid
    LineItem.reset_column_information

    LineItem.find_each do |line_item|
      line_item.update(new_order_id: line_item.order_id)
    end

    remove_column :line_items, :order_id
    rename_column :line_items, :new_order_id, :order_id
  end

  def down
    # Add code to revert the changes made in the up method
    add_column :line_items, :new_order_id, :integer
    LineItem.reset_column_information
  
    LineItem.find_each do |line_item|
      line_item.update(new_order_id: line_item.order_id)
    end
  
    remove_column :line_items, :order_id
    rename_column :line_items, :new_order_id, :order_id
  end
  
end
