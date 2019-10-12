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

  let(:company) { create(:company) }

  it 'should send an email' do
    InviteUserMailer.send_email('any email', company).deliver_now
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end
end
