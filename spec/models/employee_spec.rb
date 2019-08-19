# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Employee, type: :model do
  it 'is valid with valid attributes' do
    company = Company.new(name: 'Company')
    account = Account.new(name: 'Simone',
                          surname: 'Simeone',
                          date_of_birth: '2019-04-08',
                          email: 'sim23@rspec.com',
                          password: '123456')
    expect(company.save).to be_truthy
    expect(account.save).to be_truthy

    employee = Employee.new(start_day: '2019-04-08',
                            position: 'Boss',
                            is_enabled: true,
                            account_id: account.id,
                            company_id: company.id,
                            role: 'owner')
    expect(employee).to be_valid
  end

  it 'is valid without position' do
    company = Company.new(name: 'Company')
    account = Account.new(name: 'Simone',
                          surname: 'Simeone',
                          date_of_birth: '2019-04-08',
                          email: 'sim23@rspec.com',
                          password: '123456')
    expect(company.save).to be_truthy
    expect(account.save).to be_truthy

    employee = Employee.new(start_day: '2019-04-08',
                            is_enabled: true,
                            account_id: account.id,
                            company_id: company.id,
                            role: 'owner')
    expect(employee).to be_valid
  end

  it 'is invalid without start_day' do
    company = Company.new(name: 'Company')
    account = Account.new(name: 'Simone',
                          surname: 'Simeone',
                          date_of_birth: '2019-04-08',
                          email: 'sim23@rspec.com',
                          password: '123456')
    expect(company.save).to be_truthy
    expect(account.save).to be_truthy

    employee = Employee.new(position: 'Boss',
                            is_enabled: true,
                            account_id: account.id,
                            company_id: company.id,
                            role: 'owner')
    expect(employee).to be_invalid
    expect(employee.errors.messages).to include(:start_day)
  end

  it 'is invalid without account_id' do
    company = Company.new(name: 'Company')
    expect(company.save).to be_truthy

    employee = Employee.new(start_day: '2019-04-08',
                            position: 'Boss',
                            is_enabled: true,
                            company_id: company.id,
                            role: 'owner')
    expect(employee).to be_invalid
    expect(employee.errors.messages).to include(:account)
  end

  it 'is invalid without company_id' do
    account = Account.new(name: 'Simone',
                          surname: 'Simeone',
                          date_of_birth: '2019-04-08',
                          email: 'sim23@rspec.com',
                          password: '123456')
    expect(account.save).to be_truthy

    employee = Employee.new(start_day: '2019-04-08',
                            position: 'Boss',
                            is_enabled: true,
                            account_id: account.id,
                            role: 'owner')
    expect(employee).to be_invalid
    expect(employee.errors.messages).to include(:company)
  end

  it 'is invalid with wrong role' do
    company = Company.new(name: 'Company')
    account = Account.new(name: 'Simone',
                          surname: 'Simeone',
                          date_of_birth: '2019-04-08',
                          email: 'sim23@rspec.com',
                          password: '123456')
    expect(company.save).to be_truthy
    expect(account.save).to be_truthy

    employee = Employee.new(start_day: '2019-04-08',
                            position: 'Boss',
                            is_enabled: true,
                            account_id: account.id,
                            company_id: company.id,
                            role: 'wrong_role')
    expect(employee).to be_invalid
    expect(employee.errors.messages).to include(role: ['is not included in the list'])
  end
end
