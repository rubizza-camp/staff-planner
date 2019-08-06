# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompaniesController do
  render_views

  describe 'GET index' do
    let!(:company) { create(:company) }

    it 'has a 200 status code' do
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe 'GET show' do
    let(:company) { create(:company) }

    it 'has a 200 status code' do
      get :show, params: { id: company.id }
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
    let(:company) { create(:company) }

    it 'has a 200 status code' do
      get :edit, params: { id: company.id }
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
    let(:company) { create(:company) }

    it 'updates company' do
      put :update, params: { company: { name: 'Any Name' }, id: company.id }
      expect(company.reload.name).to eq('Any Name')
      expect(response).to redirect_to(Company.last)
    end

    it 'can not updates company' do
      put :update, params: { company: { name: nil }, id: company.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'DELETE destroy' do
    let(:company) { create(:company) }

    it 'deletes company' do
      delete :destroy, params: { id: company.id }
      expect(response).to redirect_to(companies_url)
      expect(Company.count).to eq(0)
    end
  end
end
