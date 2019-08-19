require 'rails_helper'

RSpec.describe Companies::Create do
  let(:account) { create(:account) }

  describe '#call' do
    context 'with valid params' do
      let(:company_params) { { name: 'Any Name' } }
      subject(:call) { Companies::Create.new.call(company_params, account.id) }

      it 'creates company and employee' do
        expect { call }.to change { Employee.count }.by(1)
         .and change {Company.count}.by(1)
      end
    end

    context 'with company name nil' do
      let(:company_params) { { name: nil } }
      subject(:call) { Companies::Create.new.call(company_params, account.id) }

      it 'not creates company and employee' do
        expect { call }.not_to change { Employee.count } and change {Company.count}
      end
    end

    context 'with account_id nil' do
      let(:company_params) { { name: 'Any Name' } }
      subject(:call) { Companies::Create.new.call(company_params, nil) }

      it 'not creates company and employee' do
        expect { call }.not_to change { Employee.count } and change {Company.count}
      end
    end
  end
end
