class AddColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :kyc_status, :string, default: 'pending'
  end
end
