require 'rails_helper'

RSpec.describe Companies::Create do
  let(:account) { create(:account) }

  describe 'Create company and employee' do
    it 'creates company and employee' do
      company_params = { name: 'Any Name' }
      Companies::Create.new.call(company_params, account.id)
      expect(Company.count).to eq(1)
      expect(Employee.count).to eq(1)
    end

    it 'can not creates company with name nil' do
      company_params = { name: nil }
      Companies::Create.new.call(company_params, account.id)
      expect(Company.count).to eq(0)
      expect(Employee.count).to eq(0)
    end

    it 'can not creates company with account_id nil' do
      company_params = { name: 'Any Name' }
      Companies::Create.new.call(company_params, nil)
      expect(Company.count).to eq(0)
      expect(Employee.count).to eq(0)
    end
  end
end
