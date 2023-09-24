class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.jsonb :amount_details
      t.integer :invoice_id

      t.timestamps
    end
  end
end
