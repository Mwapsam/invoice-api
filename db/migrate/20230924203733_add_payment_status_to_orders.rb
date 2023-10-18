class AddPaymentStatusToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :payment_status, :boolean, default: false
  end
end
