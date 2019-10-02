class AddTableSlackNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :slack_notifications do |t|
      t.string :token
      t.boolean :is_enabled, null: false, default: false
      t.references :company, index: true, null: false, foreign_key: true

      t.timestamps
    end
  end
end
