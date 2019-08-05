# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account, type: :model do
  it 'is valid with valid attributes' do
    account = Account.new(name: 'Simon',
                          surname: 'Simeone',
                          date_of_birth: '2019-04-08',
                          email: 'simon@rspec.com',
                          password: '123456')
    expect(account).to be_valid
  end

  it 'is valid without date_of_birth' do
    account = Account.new(name: 'Simon',
                          surname: 'Simeone',
                          email: 'simon@rspec.com',
                          password: '123456')
    expect(account).to be_valid
  end

  it 'is invalid without email' do
    account = Account.new(name: 'Simon',
                          surname: 'Simeone', 
                          date_of_birth: '2019-04-08',
                          password: '123456')
    expect(account).to be_invalid
    expect(account.errors.messages).to include(:email)
  end

  it 'is invalid with to same email' do
    account = Account.new(name: 'Simon',
                          surname: 'Simeone',
                          date_of_birth: '2019-04-08',
                          email: 'simon@rspec.com',
                          password: '123456')
    account2 = Account.new(name: 'Sim',
                          surname: 'Sim',
                          date_of_birth: '2019-04-08',
                          email: 'simon@rspec.com',
                          password: '123456')
    expect(account.save).to be_truthy
    expect(account2.save).to be_falsey
    expect(account2.errors.messages).to include(:email)
  end

  it 'is invalid without password' do
    account = Account.new(surname: 'Simeone', 
                          date_of_birth: '2019-04-08', 
                          email: 'simon@rspec.com')
    expect(account).to be_invalid
    expect(account.errors.messages).to include(:name)
  end


  it 'is invalid with password shorter than 6 letters/digits' do
    account = Account.new(surname: 'Simeone', 
                          date_of_birth: '2019-04-08', 
                          email: 'simon@rspec.com',
                          password: '123')
    expect(account).to be_invalid
    expect(account.errors.messages).to include(:password)
  end

  it 'is invalid without name' do
    account = Account.new(surname: 'Simeone', 
                          date_of_birth: '2019-04-08', 
                          email: 'simon@rspec.com',
                          password: '123456')
    expect(account).to be_invalid
    expect(account.errors.messages).to include(:name)
  end

  it 'is invalid without surname' do
    account = Account.new(name: 'Simon', 
                          date_of_birth: '2019-04-08', 
                          email: 'simon@rspec.com',
                          password: '123456')
    expect(account).to be_invalid
    expect(account.errors.messages).to include(:surname)
  end
end
