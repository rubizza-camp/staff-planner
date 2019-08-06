require 'rails_helper'

RSpec.describe Rule, type: :model do
  it 'is valid with valid attributes' do
    company = Company.create(name: 'MyCompany')
    rule = Rule.new(name: 'Holiday',
                    company_id: company.id,
                    period: 'year')
    expect(rule).to be_valid
  end

  it 'is invalid without name' do
    company = Company.create(name: 'MyCompany')
    rule = Rule.new(company_id: company.id,
                    period: 'year')
    expect(rule).to be_invalid
    expect(rule.errors.messages).to include(:name)
  end

  it 'is invalid without company_id' do
    rule = Rule.new(name: 'Holiday',
                    period: 'year')
    expect(rule).to be_invalid
    expect(rule.errors.messages).to include(:company_id)
  end

  it 'is invalid without period' do
    company = Company.create(name: 'MyCompany')
    rule = Rule.new(name: 'Holiday',
                    company_id: company.id)
    expect(rule).to be_invalid
    expect(rule.errors.messages).to include(:period)
  end
end
