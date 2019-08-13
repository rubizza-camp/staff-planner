# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompaniesController do
  before(:each) do
    @account = FactoryBot.create(:account)
    @company = FactoryBot.create(:company)
    sign_in @account
  end

  describe 'GET index' do
    it 'has a 200 status code' do
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe 'GET show' do
    it 'has a 200 status code' do
      get :show, params: { id: @company.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'GET new' do
    it 'has a 200 status code' do
      get :new
      expect(response.status).to eq(200)
    end
  end

  describe 'GET calendar' do
    it 'has a 200 status code' do
      get :calendar, params: { company_id: @company.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'GET edit' do
    it 'has a 200 status code' do
      get :edit, params: { id: @company.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'POST create' do
    it 'creates company' do
      post :create, params: { company: { name: 'Any Name' } }
      expect(response).to redirect_to(Company.last)
    end

    it 'can not creates company' do
      post :create, params: { company: { name: nil } }
      expect(response.status).to eq(200)
    end
  end

  describe 'PUT update' do
    it 'updates company' do
      put :update, params: { company: { name: 'Any Name' }, id: @company.id }
      expect(@company.reload.name).to eq('Any Name')
      expect(response).to redirect_to(Company.last)
    end

    it 'can not updates company' do
      put :update, params: { company: { name: nil }, id: @company.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes company' do
      delete :destroy, params: { id: @company.id }
      expect(response).to redirect_to(companies_url)
      expect(Company.count).to eq(0)
    end
  end
end
