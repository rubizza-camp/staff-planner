class AddStatusToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :state, :string, null: false, default: 'pending'
  end
end
