class CreateHolidays < ActiveRecord::Migration[5.2]
  def change
    create_table :holidays do |t|
      t.string :name, null: false
      t.date :date, null: false
      t.references :company, index: true, null: false, foreign_key: true

      t.timestamps
    end
  end
end
