# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompaniesController do
  render_views

  describe 'GET index' do
    let!(:company) { create(:company) }
    let(:account) { create(:account) }

    it 'has a 200 status code' do
      sign_in account
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe 'GET show' do
    let(:company) { create(:company) }
    let(:account) { create(:account) }

    it 'has a 200 status code' do
      sign_in account
      get :show, params: { id: company.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'GET new' do
    let(:account) { create(:account) }
    
    it 'has a 200 status code' do
      sign_in account
      get :new
      expect(response.status).to eq(200)
    end
  end

  describe 'GET calendar' do
    let(:company) { create(:company) }
    let(:account) { create(:account) }

    it 'has a 200 status code' do
      sign_in account
      get :calendar, params: { company_id: company.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'GET edit' do
    let(:company) { create(:company) }
    let(:account) { create(:account) }

    it 'has a 200 status code' do
      sign_in account
      get :edit, params: { id: company.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'POST create' do
    let(:account) { create(:account) }
    it 'creates company' do
      sign_in account
      post :create, params: { company: { name: 'Any Name' } }
      expect(response).to redirect_to(Company.last)
    end

    it 'can not creates company' do
      sign_in account
      post :create, params: { company: { name: nil } }
      expect(response.status).to eq(200)
    end
  end

  describe 'PUT update' do
    let(:company) { create(:company) }
    let(:account) { create(:account) }

    it 'updates company' do
      sign_in account
      put :update, params: { company: { name: 'Any Name' }, id: company.id }
      expect(company.reload.name).to eq('Any Name')
      expect(response).to redirect_to(Company.last)
    end

    it 'can not updates company' do
      sign_in account
      put :update, params: { company: { name: nil }, id: company.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'DELETE destroy' do
    let(:company) { create(:company) }
    let(:account) { create(:account) }

    it 'deletes company' do
      sign_in account
      delete :destroy, params: { id: company.id }
      expect(response).to redirect_to(companies_url)
      expect(Company.count).to eq(0)
    end
  end
end
