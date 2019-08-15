# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HolidaysController do
  render_views

  let(:company) { FactoryBot.create(:company) }
  let(:holiday) { FactoryBot.create(:holiday, company_id: company.id) }

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
      get :show, params: { id: holiday.id,
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
      get :edit, params: { id: holiday.id,
                           company_id: company.id }
      expect(response.status).to eq(200)
    end

    let(:holiday2) { FactoryBot.create(:holiday, company_id: company_without_access.id) }
    let(:company_without_access) { FactoryBot.create(:company) }
    it 'has a 302 status code' do
      get :edit, params: { id: holiday2.id,
                           company_id: company_without_access.id }
      expect(response.status).to eq(302)
    end
  end

  describe 'POST create' do
    it 'creates holiday' do
      post :create, params: { holiday: { date: Date.today + 1,
                                         name: 'Lengaz' },
                              company_id: company.id }
      expect(response).to redirect_to company_holidays_url(company_id: company.id)
    end

    it 'can not creates holiday' do
      post :create, params: { holiday: { date: Date.today - 1 },
                              company_id: company.id  }
      expect(response.status).to eq(200)
    end
  end

  describe 'PUT update' do
    it 'updates holiday' do
      put :update, params: { holiday: { date: Date.today + 7 },
                             id: holiday.id,
                             company_id: company.id }
      expect(holiday.reload.date).to eq(Date.today + 7)
      expect(response).to redirect_to company_holidays_url(company_id: company.id)
    end

    it 'can not updates holiday' do
      put :update, params: { holiday: { date: Date.today - 7 },
                             id: holiday.id,
                             company_id: company.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes holiday' do
      delete :destroy, params: { id: holiday.id,
                                 company_id: company.id }
      expect(response).to redirect_to(company_holidays_url(company.id))
      expect(Holiday.count).to eq(0)
    end
  end
end
