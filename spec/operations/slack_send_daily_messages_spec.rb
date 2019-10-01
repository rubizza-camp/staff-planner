# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Companies::Create do
  let(:slack_notifier) { double("Slack::Notifier", ping: 'hello') }
  let(:event) { create(:event) }

  before do
    allow(Slack::Notifier).to receive(:new).and_return(slack_notifier)

    company = FactoryBot.create(:company)
    FactoryBot.create(:event, company_id: company.id)
    FactoryBot.create(:slack_notification, company_id: company.id)
  end

  describe '#call' do
    it "pings messages" do
      expect(slack_notifier).to receive(:ping).with("1) Simonee Simon. holiday (pending)\n")
      Slack::SendDailyMessages.new.call
    end
  end
end
