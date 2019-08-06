# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'accounts/show', type: :view do
  before(:each) do
    @account = assign(:account, Account.create!(name: 'Simon',
                                                surname: 'Simon',
                                                email: 'simon@gmail.com',
                                                password: '123456'))
  end

  it 'renders attributes in <p>' do
    render
  end
end
