# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RulesController do
  #render_views

  describe 'GET index' do
    let!(:rule) { create(:rule) }
    let(:account) { create(:account) }

    it 'has a 200 status code' do
      sign_in account
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe 'GET show' do
    let(:rule) { create(:rule) }
    let(:account) { create(:account) }

    it 'has a 200 status code' do
      sign_in account
      get :show, params: { id: rule.id }
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

  describe 'GET edit' do
    let(:rule) { create(:rule) }
    let(:account) { create(:account) }

    it 'has a 200 status code' do
      sign_in account
      get :edit, params: { id: rule.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'POST create' do
    let(:account) { create(:account) }
    it 'creates rule' do
      sign_in account
      company_id = Company.create(name: 'MyCompany').id
      post :create, params: { rule: { name: 'Any',
                                      company_id: company_id,
                                      allowance_days: 1,
                                      period: 'year' } }
      expect(response).to redirect_to(Rule.last)
    end

    it 'can not creates rule' do
      sign_in account
      post :create, params: { rule: { name: nil } }
      expect(response.status).to eq(200)
    end
  end

  describe 'PUT update' do
    let(:rule) { create(:rule) }
    let(:account) { create(:account) }

    it 'updates rule' do
      sign_in account
      put :update, params: { rule: { name: 'Other Name' }, id: rule.id }
      expect(rule.reload.name).to eq('Other Name')
      expect(response).to redirect_to(Rule.last)
    end

    it 'can not updates rule' do
      sign_in account
      put :update, params: { rule: { name: nil }, id: rule.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'DELETE destroy' do
    let(:rule) { create(:rule) }
    let(:account) { create(:account) }

    it 'deletes rule' do
      sign_in account
      delete :destroy, params: { id: rule.id }
      expect(response).to redirect_to(rules_url)
      expect(Rule.count).to eq(0)
    end
  end
end
