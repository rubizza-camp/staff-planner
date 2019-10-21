# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Events::Create do
  let(:account) { create(:account) }

  describe '#call' do
    context 'with valid params' do
      let(:company) { create(:company) }
      let(:employee) { create(:employee, company: company, account: account) }
      let(:params) do
        { start_period: Date.today.to_datetime.change(hour: Event::START_DAY),
          end_period: Date.today.to_datetime.change(hour: Event::END_DAY),
          rule_id: rule.id,
          reason: 'any reason',
          employee_id: employee.id,
          company_id: company.id }
      end

      let(:rule) { create(:rule, company: company) }
      let(:event_mailer) { double EventMailer }

      subject(:call) { Events::Create.new(account).call(params) }

      before do
        allow(EventMailer).to receive(:send_email).and_return(event_mailer)
      end

      it 'creates event and send letter' do
        expect(event_mailer).to receive(:deliver_later)
        expect { call }.to change { Event.count }.by(1)
      end
    end

    context 'with invalid params' do
      let(:company) { create(:company) }
      let(:employee) { create(:employee, company: company, account: account) }
      let(:params) do
        { start_period: Date.today.to_datetime.change(hour: Event::START_DAY),
          end_period: Date.today.to_datetime.change(hour: Event::END_DAY),
          rule_id: rule.id,
          reason: 'any reason',
          company_id: company.id }
      end
      let(:rule) { create(:rule, company: company) }

      subject(:call) { Events::Create.new(account).call(params) }

      it 'not creates event' do
        expect { call }.to change { Event.count }.by(0)
      end
    end

    context 'with event not suitable for AllowanceService' do
      let(:company) { create(:company) }
      let(:employee) { create(:employee, company: company, account: account) }
      let(:params) do
        { start_period: Date.today.to_datetime.change(hour: Event::START_DAY),
          end_period: (Date.today + rule.allowance_days + 1).to_datetime.change(hour: Event::END_DAY),
          rule_id: rule.id,
          reason: 'any reason',
          employee_id: employee.id,
          company_id: company.id }
      end
      let(:rule) { create(:rule, company: company) }

      subject(:call) { Events::Create.new(account).call(params) }

      it 'not creates event' do
        expect { call }.to change { Event.count }.by(0)
      end
    end
  end
end
