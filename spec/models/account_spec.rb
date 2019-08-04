# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account, type: :model do
  it 'is valid with valid attributes' do
    account = Account.new(name: 'Simon',
                          surname: 'Simeone',
                          date_of_birth: '2019-04-08')
    expect(account.save).to be_truthy
  end

  it 'is valid without date_of_birth' do
    account = Account.new(name: 'Simon',
                          surname: 'Simeone')
    expect(account.save).to be_truthy
  end

  it 'is invalid without name' do
    account = Account.new(surname: 'Simeone', date_of_birth: '2019-04-08')
    expect { account.save }.to raise_error(ActiveRecord::NotNullViolation)
  end

  it 'is invalid without surname' do
    account = Account.new(name: 'Simon', date_of_birth: '2019-04-08')
    expect { account.save }.to raise_error(ActiveRecord::NotNullViolation)
  end
end
