class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :phone_number
      t.string :role, default: 'client'
      t.string :password_digest
      t.boolean :approved, default: false
      t.integer :account_balance, default: 0

      t.timestamps
    end
  end
end