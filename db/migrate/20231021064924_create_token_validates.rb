class CreateTokenValidates < ActiveRecord::Migration[7.0]
  def change
    create_table :token_validates, id: :uuid do |t|
      t.string :token
      t.boolean :is_valid, default: false
      t.timestamps
    end
  end
end
