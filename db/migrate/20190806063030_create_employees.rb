class CreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees do |t|
      t.date :start_day, null: false
      t.string :position
      t.boolean :is_enabled, null: false, default: true
      t.references :account, index: true, null: false, foreign_key: true
      t.references :company, index: true, null: false, foreign_key: true

      t.timestamps
    end
  end
end
