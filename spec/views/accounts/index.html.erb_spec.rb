# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'accounts/index', type: :view do
  before(:each) do
    assign(:accounts, [
             Account.create!(name: 'Simon',
                             surname: 'Simon',
                             email: 'simon@gmail.com',
                             password: '123456'),
             Account.create!(name: 'Simonelli',
                             surname: 'Simonelli',
                             email: 'simonelli@gmail.com',
                             password: '123456')
           ])
  end

  it 'renders a list of accounts' do
    render
  end
end
