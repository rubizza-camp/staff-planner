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
      get :index, params: { company_id: company.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'GET show' do
    it 'has a 200 status code' do
      get :show, params: { id: working_day.id,
                           company_id: company.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'GET new' do
    it 'has a 200 status code' do
      get :new, params: { company_id: company.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'GET edit' do
    it 'has a 200 status code' do
      get :edit, params: { id: working_day.id,
                           company_id: company.id }
      expect(response.status).to eq(200)
    end

    let(:working_day2) { FactoryBot.create(:working_day, company_id: company_without_access.id) }
    let(:company_without_access) { FactoryBot.create(:company) }
    it 'has a 302 status code' do
      get :edit, params: { id: working_day2.id,
                           company_id: company_without_access.id }
      expect(response.status).to eq(302)
    end
  end

  describe 'POST create' do
    it 'creates working_day' do
      post :create, params: { working_day: { day_of_week: rand(7) },
                              company_id: company.id }
      expect(response).to redirect_to company_working_days_path(company_id: company.id)
    end

    it 'can not creates working_day' do
      post :create, params: { working_day: { day_of_week: -1 },
                              company_id: company.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'PUT update' do
    it 'updates working_day' do
      put :update, params: { working_day: { day_of_week: 2 },
                             id: working_day.id,
                             company_id: company.id }
      expect(working_day.reload.day_of_week).to eq(2)
      expect(response).to redirect_to company_working_days_path(company_id: company.id)
    end

    it 'can not updates working_day' do
      put :update, params: { working_day: { day_of_week: -1 },
                             id: working_day.id,
                             company_id: company.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes working_day' do
      delete :destroy, params: { id: working_day.id,
                                 company_id: company.id }
      expect(response).to redirect_to(company_working_days_url(company.id))
      expect(WorkingDay.count).to eq(0)
    end
  end
end
