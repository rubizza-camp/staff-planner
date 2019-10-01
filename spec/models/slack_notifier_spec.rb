# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SlackNotification do
  context 'with valid attributess' do
    let(:slack_notification) { create(:slack_notification) }

    it 'is valid' do
      expect(slack_notification).to be_valid
    end
  end

  context 'with wrong company_id' do
    let(:slack_notification) { build(:slack_notification, company_id: 'wrong_id') }

    it 'is invalid' do
      expect(slack_notification).to be_invalid
      expect(slack_notification.errors.messages).to include(company: ['must exist'])
    end
  end

  context 'with wrong is_enabled' do
    let(:slack_notification) { build(:slack_notification, is_enabled: nil) }

    it 'is invalid' do
      expect(slack_notification).to be_invalid
      expect(slack_notification.errors.messages).to include(is_enabled: ['is not included in the list'])
    end
  end
end
