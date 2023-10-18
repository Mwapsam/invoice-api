class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table "customers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.string :email
      t.string :merchant_customer_id

      t.timestamps
    end
  end
end
