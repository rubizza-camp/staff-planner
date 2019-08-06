require 'rails_helper'

RSpec.describe "employees/index", type: :view do
  before(:each) do
    assign(:employees, [
      Employee.create!(),
      Employee.create!()
    ])
  end

  it "renders a list of employees" do
    render
  end
end
