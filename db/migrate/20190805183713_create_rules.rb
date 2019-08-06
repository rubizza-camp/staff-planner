class CreateRules < ActiveRecord::Migration[5.2]
  def change
    create_table :rules do |t|
      t.string :name, null: false
      t.integer :company_id, foreign_key: true, index: true, null: false
      t.integer :alowance_days
      t.string :period, null: false
      t.boolean :is_enabled

      t.timestamps
    end
  end
end
