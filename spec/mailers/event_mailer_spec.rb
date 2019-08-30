# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventMailer do
  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  context 'without params' do
    it 'should not proceed if params nil' do
      EventMailer.send_email(nil, nil, nil).deliver_now
      expect(ActionMailer::Base.deliveries.count).to eq(0)
    end
  end

  context 'with valid params' do
    let(:company) { create(:company) }
    let(:event) { create(:event, company: company, employee: employee) }
    let(:account) { create(:account) }
    let!(:employee) { create(:employee, company: company, account: account) }

    it 'should send an email' do
      EventMailer.send_email(company, event, account).deliver_now
      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(ActionMailer::Base.deliveries.first.to.first).to eq(account.email)
    end
  end
end
