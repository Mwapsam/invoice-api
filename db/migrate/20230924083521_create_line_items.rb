class CreateLineItems < ActiveRecord::Migration[7.0]
  def change
    create_table "line_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.string :product_sku
      t.string :product_name
      t.integer :quantity
      t.decimal :unit_price
      t.decimal :discount_amount
      t.decimal :tax_amount
      t.decimal :tax_rate
      t.decimal :total_amount
      t.integer :order_id

      t.timestamps
    end
  end
end
