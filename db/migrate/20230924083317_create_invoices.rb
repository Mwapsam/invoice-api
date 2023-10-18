class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table "invoices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.string :description
      t.date :due_date
      t.boolean :send_immediately
      t.boolean :allow_partial_payments
      t.string :delivery_mode
      t.integer :customer_id

      t.timestamps
    end
  end
end
