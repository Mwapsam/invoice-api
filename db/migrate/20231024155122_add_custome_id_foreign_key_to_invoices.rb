class AddCustomeIdForeignKeyToInvoices < ActiveRecord::Migration[7.0]
  def up
    change_column :invoices, :customer_id, :uuid, using: 'customer_id::uuid', null: false, foreign_key: true
  end

  def down
    change_column :invoices, :customer_id, :string
  end
end
