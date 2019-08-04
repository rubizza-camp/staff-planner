class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :name, null: false
      t.string :surname, null: false
      t.string :email, null: false, index: { unique: true }
      t.date :date_of_birth

      t.timestamps
    end
  end
end
