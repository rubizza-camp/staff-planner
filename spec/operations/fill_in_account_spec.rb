# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Employees::FillInAccount do
  describe '#call' do
    let(:employee) { create(:employee, account: nil) }
    let(:account) { create(:account, email: employee.email) }

    it 'fill_account_id' do
      expect(employee.account_id).to eq(nil)
      Employees::FillInAccount.new.call(account)
      expect(employee.reload.account_id).to eq(account.id)
    end
  end
end
