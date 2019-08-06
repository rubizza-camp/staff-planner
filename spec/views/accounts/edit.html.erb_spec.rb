require 'rails_helper'

RSpec.describe "accounts/edit", type: :view do
  before(:each) do
    @account = assign(:account, Account.create!(name: 'Simon',
    											surname: 'Simon',
    											email: 'simon@gmail.com',
    											password: '123456'))
  end

  it "renders the edit account form" do
    render

    assert_select "form[action=?][method=?]", account_path(@account), "post" do
    end
  end
end
