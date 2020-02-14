class AddColorToRules < ActiveRecord::Migration[5.2]
  def change
    add_column :rules, :color, :string, default: "#44c9b3", null: false
  end
end
