class CreateAuditLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :audit_logs, id: :uuid do |t|
      t.string :action
      t.string :action_details
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
