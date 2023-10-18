class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table "orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.jsonb :amount_details
      t.integer :invoice_id

      t.timestamps
    end
  end
end
