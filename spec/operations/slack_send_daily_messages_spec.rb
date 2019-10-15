# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Companies::Create do
  let(:slack_notifier) { double('Slack::Notifier') }
  let(:event) { create(:event) }

  before do
    allow(Slack::Notifier).to receive(:new).and_return(slack_notifier)

    company = create(:company)
    create(:event, company_id: company.id)
    create(:slack_notification, company_id: company.id)
  end

  describe '#call' do
    it 'pings messages' do
      message = "1. Simon. MyString [holiday] (not approved yet)\n"
      expect(slack_notifier).to receive(:ping).with(message)
      Slack::SendDailyMessages.new.call
    end
  end
end
