class AddAdditionalFieldsToCustomers < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :first_name, :string
    add_column :customers, :last_name, :string
    add_column :customers, :address1, :string
    add_column :customers, :locality, :string
    add_column :customers, :administrative_area, :string
    add_column :customers, :postal_code, :string
    add_column :customers, :country, :string
    add_column :customers, :phone_number, :string
  end
end
