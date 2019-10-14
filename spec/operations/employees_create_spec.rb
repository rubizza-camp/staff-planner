# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Employees::Create do
  let(:account) { create(:account) }

  describe '#call' do


    context 'with valid params' do
      let(:company) { create(:company) }
      let(:invite_user_mailer) { double InviteUserMailer }

      before do
        allow(InviteUserMailer).to receive(:send_email).and_return(invite_user_mailer)
      end

      it 'creates employee and send email' do
        expect(invite_user_mailer).to receive(:deliver_later)
        expect { described_class.new.call(
          {
            is_enabled: true,
            position: 'any position',
            start_day: '2019-02-02',
            email: 'any email',
            role: 'owner'
          },
          company)
        }.to(change { Employee.count })
      end

      it 'creates employee and not send email' do
        expect(invite_user_mailer).not_to receive(:deliver_later)
        expect { described_class.new.call(
          {
            is_enabled: true,
            position: 'any position',
            start_day: '2019-02-02',
            email: account.email,
            role: 'owner'
          },
          company)
        }.to(change { Employee.count })
      end
    end
  end
end
