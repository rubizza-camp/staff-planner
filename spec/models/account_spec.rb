# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account, type: :model do
  it 'is valid with valid attributes' do
    account = Account.new(name: 'Simon',
                          surname: 'Simeone',
                          email: 'simon@rspec.com',
                          date_of_birth: '2019-04-08')
    expect(account.save).to be_truthy
  end

  it 'is valid without date_of_birth' do
    account = Account.new(name: 'Simon',
                          surname: 'Simeone',
                          email: 'simon@rspec.com')
    expect(account.save).to be_truthy
  end

  it 'is invalid without name' do
    account = Account.new(surname: 'Simeone', email: 'simon@rspec.com')
    expect { account.save }.to raise_error(ActiveRecord::NotNullViolation)
  end

  it 'is invalid without surname' do
    account = Account.new(name: 'Simon', email: 'simon@rspec.com')
    expect { account.save }.to raise_error(ActiveRecord::NotNullViolation)
  end

  it 'is invalid when create new account with not unique email' do
    account = Account.new(name: 'Simon',
                          surname: 'Simeone',
                          email: 'simon@rspec.com')
    account2 = Account.new(name: 'Sim',
                           surname: 'Sim',
                           email: 'simon@rspec.com')
    expect(account.save).to be_truthy
    expect { account2.save }.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it 'is valid when create new account with two different emails' do
    account = Account.new(name: 'Simon',
                          surname: 'Simeone',
                          email: 'simon@rspec.com')
    account2 = Account.new(name: 'Sim',
                           surname: 'Sim',
                           email: 'sim@mail.com')
    expect(account.save).to be_truthy
    expect(account2.save).to be_truthy
  end
end
