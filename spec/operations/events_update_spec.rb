# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Events::Update do
  let(:account) { create(:account) }

  describe '#call' do
    context 'with valid params' do
      let(:company) { create(:company) }
      let(:employee) { create(:employee, company: company, account: account) }
      let(:params) do
        { start_period: Date.today.to_datetime.change(hour: Event::START_DAY),
          end_period: Date.today.to_datetime.change(hour: Event::END_DAY),
          rule_id: rule.id,
          reason: 'new reason',
          employee_id: employee.id,
          company_id: company.id }
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
        { start_period: Date.today.to_datetime.change(hour: Event::START_DAY),
          end_period: (Date.today + rule.allowance_days + 1).to_datetime.change(hour: Event::END_DAY),
          rule_id: rule.id,
          reason: 'new reason',
          employee_id: employee.id,
          company_id: company.id }
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
