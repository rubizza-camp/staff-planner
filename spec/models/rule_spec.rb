require 'rails_helper'

RSpec.describe Rule, type: :model do
  it 'is valid with valid attributes' do
    company = Company.create(name: 'MyCompany')
    rule = Rule.new(name: 'Holiday',
                    company_id: company.id,
                    period: 'year',
                    alowance_days: 1)
    expect(rule).to be_valid
  end

  it 'is invalid without name' do
    company = Company.create(name: 'MyCompany')
    rule = Rule.new(company_id: company.id,
                    period: 'year',
                    alowance_days: 1)
    expect(rule).to be_invalid
    expect(rule.errors.messages).to include(:name)
  end

  it 'is invalid with wrong company_id' do
    rule = Rule.new(name: 'Holiday',
                    company_id: 'wrong_id',
                    period: 'year',
                    alowance_days: 1)
    expect(rule).to be_invalid
    expect(rule.errors.messages).to include(company: ["must exist"])
  end

  it 'is invalid without period' do
    company = Company.create(name: 'MyCompany')
    rule = Rule.new(name: 'Holiday',
                    company_id: company.id,
                    alowance_days: 1)
    expect(rule).to be_invalid
    expect(rule.errors.messages).to include(:period)
  end

  it 'is invalid with wrong alowance_days' do
    company = Company.create(name: 'MyCompany')
    rule = Rule.new(name: 'Holiday',
                    company_id: company.id,
                    period: 'year',
                    alowance_days: -1)
    expect(rule).to be_invalid
    expect(rule.errors.messages).to include(:alowance_days)
  end
end
