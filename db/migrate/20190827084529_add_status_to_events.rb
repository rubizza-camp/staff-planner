class AddStatusToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :aasm_state, :string, null: false, default: 'pending'
  end
end
