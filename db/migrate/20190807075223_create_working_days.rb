class CreateWorkingDays < ActiveRecord::Migration[5.2]
  def change
    create_table :working_days do |t|
      t.references :company, index: true, null: false, foreign_key: true
      t.integer :day_of_week, null: false

      t.timestamps
    end
  end
end
