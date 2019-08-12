class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.datetime :start_period, null: false
      t.datetime :end_period, null: false
      t.string :reason
      t.references :employee, foreign_key: true, null: false
      t.references :company, foreign_key: true
      t.references :rule, foreign_key: true, null: false

      t.timestamps
    end
  end
end
