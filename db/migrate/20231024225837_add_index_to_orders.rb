class AddIndexToOrders < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :orders, :invoices, column: :invoice_id
    add_foreign_key :line_items, :orders, column: :order_id
  end
end
