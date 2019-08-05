class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :name, null: false
      t.string :surname, null: false
      t.date :date_of_birth

      t.timestamps
    end
  end
end
