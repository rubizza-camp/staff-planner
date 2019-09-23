# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkingDaysController do
  render_views

  let(:company) { FactoryBot.create(:company) }
  let(:working_day) { FactoryBot.create(:working_day, company_id: company.id) }

  before(:each) do
    account = FactoryBot.create(:account)
    employee = FactoryBot.create(:employee, company_id: company.id, account_id: account.id)
    sign_in account
  end

  describe 'GET index' do
    it 'has a 200 status code' do
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe 'GET show' do
    it 'has a 200 status code' do
      get :show, params: { id: working_day.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'GET new' do
    it 'has a 200 status code' do
      get :new
      expect(response.status).to eq(200)
    end
  end

  describe 'GET edit' do
    it 'has a 200 status code' do
      get :edit, params: { id: working_day.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'POST create' do
    it 'creates working_day' do
      post :create, params: { working_day: { day_of_week: rand(7) } }
      expect(response).to redirect_to working_days_path
    end

    it 'can not creates working_day' do
      post :create, params: { working_day: { day_of_week: -1 } }
      expect(response.status).to eq(200)
    end
  end

  describe 'PUT update' do
    it 'updates working_day' do
      put :update, params: { working_day: { day_of_week: 2 },
                             id: working_day.id }
      expect(working_day.reload.day_of_week).to eq(2)
      expect(response).to redirect_to working_days_path
    end

    it 'can not updates working_day' do
      put :update, params: { working_day: { day_of_week: -1 },
                             id: working_day.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes working_day' do
      delete :destroy, params: { id: working_day.id }
      expect(response).to redirect_to working_days_path
      expect(WorkingDay.count).to eq(0)
    end
  end
end
