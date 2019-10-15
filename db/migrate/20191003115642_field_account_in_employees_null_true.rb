class FieldAccountInEmployeesNullTrue < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :email, :string, default: "", null: false
    change_column_null :employees, :account_id, true

    Employee.all.includes(:account).each do |employee|
      employee.update_attribute(:email, employee.account.email)
    end
  end
end
