# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Events::Update do
  let(:account) { create(:account) }

  describe '#call' do
    context 'with valid params' do
      let(:company) { create(:company) }
      let(:employee) { create(:employee, company: company, account: account) }
      let(:params) do
        ActionController::Parameters.new(event: { rule_id: rule.id,
                                                  start_day: Date.today,
                                                  end_day: Date.today,
                                                  reason: 'new reason' })
      end
      let(:event) do
        create(:event, company: company,
                       account: account,
                       employee: employee,
                       state: 'accepted')
      end
      let(:rule) { create(:rule, company: company) }
      let(:event_mailer) { double EventMailer }

      before do
        allow(EventMailer).to receive(:send_email).and_return(event_mailer)
      end

      it 'update event' do
        expect(event_mailer).to receive(:deliver_later)
        Events::Update.new(account).call(event, params)
        expect(Event.first.reason).to eq('new reason')
      end
    end

    context 'with changed event not suitable for AllowanceService' do
      let(:company) { create(:company) }
      let(:employee) { create(:employee, company: company, account: account) }
      let(:params) do
        ActionController::Parameters.new(event: { rule_id: rule.id,
                                                  start_day: Date.today,
                                                  end_day: Date.today + rule.allowance_days + 1,
                                                  reason: 'new reason' })
      end
      let(:event) do
        create(:event, company: company,
                       account: account,
                       employee: employee,
                       state: 'accepted',
                       reason: 'old reason')
      end
      let(:rule) { create(:rule, company: company) }
      let(:event_mailer) { double EventMailer }

      before do
        allow(EventMailer).to receive(:send_email).and_return(event_mailer)
      end

      it 'not change event' do
        expect(event_mailer).not_to receive(:deliver_later)
        Events::Update.new(account).call(event, params)
        expect(Event.first.reason).to eq('old reason')
      end
    end
  end
end
