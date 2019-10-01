# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SlackNotificationsController do
  render_views

  let(:company) { FactoryBot.create(:company) }
  let!(:slack_notification) { FactoryBot.create(:slack_notification, company_id: company.id) }

  before(:each) do
    account = FactoryBot.create(:account)
    employee = FactoryBot.create(:employee, company_id: company.id, account_id: account.id)
    sign_in account
  end

  describe 'GET new' do
    it 'has a 200 status code' do
      get :new
      expect(response.status).to eq(200)
    end
  end

  describe 'GET edit' do
    it 'has a 200 status code' do
      get :edit
      expect(response.status).to eq(200)
    end
  end

  describe 'POST create' do
    it 'creates slack_notification' do
      post :create, params: { slack_notification: { is_enabled: true, token: 'anything' } }
      expect(response).to redirect_to company_path(company)
    end

    it 'can not creates slack_notification' do
      post :create, params: { slack_notification: { is_enabled: nil, token: 'anything' } }
      expect(response.status).to eq(200)
    end
  end

  describe 'PUT update' do
    it 'updates slack_notification' do
      put :update, params: { slack_notification: { is_enabled: false },
                             id: slack_notification.id }
      expect(response).to redirect_to company_path(company)
    end

    it 'can not updates slack_notification' do
      put :update, params: { slack_notification: { is_enabled: nil },
                             id: slack_notification.id }
      expect(response.status).to eq(200)
    end
  end
end
