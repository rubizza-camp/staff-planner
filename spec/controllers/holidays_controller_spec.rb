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
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe 'GET show' do
    it 'has a 200 status code' do
      get :show, params: { id: holiday.id }
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
      get :edit, params: { id: holiday.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'POST create' do
    it 'creates holiday' do
      post :create, params: { holiday: { date: Date.today + 1,
                                         name: 'Lengaz' } }
      expect(response).to redirect_to holidays_path
    end

    it 'can not creates holiday' do
      post :create, params: { holiday: { date: Date.today - 1 } }
      expect(response.status).to eq(200)
    end
  end

  describe 'PUT update' do
    it 'updates holiday' do
      put :update, params: { holiday: { date: Date.today + 7 },
                             id: holiday.id }
      expect(holiday.reload.date).to eq(Date.today + 7)
      expect(response).to redirect_to holidays_path
    end

    it 'can not updates holiday' do
      put :update, params: { holiday: { date: Date.today - 7 },
                             id: holiday.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes holiday' do
      delete :destroy, params: { id: holiday.id }
      expect(response).to redirect_to holidays_path
      expect(Holiday.count).to eq(0)
    end
  end
end
