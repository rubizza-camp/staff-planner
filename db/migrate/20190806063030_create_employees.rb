class CreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees do |t|
      t.date :start_day, null: false
      t.string :position
      t.boolean :is_enabled
      t.references :account, index: true, null: false
      t.references :company, index: true, null: false

      t.timestamps
    end
  end
end
