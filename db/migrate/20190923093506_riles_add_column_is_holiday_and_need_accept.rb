class RilesAddColumnIsHolidayAndNeedAccept < ActiveRecord::Migration[5.2]
  def change
    add_column :rules, :is_holiday, :boolean, null: false, default: true
    add_column :rules, :auto_confirm, :boolean, null: false, default: false
  end
end
