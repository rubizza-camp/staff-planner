# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RulesController do
  render_views

  let(:company) { FactoryBot.create(:company) }
  let(:rule) { FactoryBot.create(:rule, company_id: company.id) }

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
      get :show, params: { id: rule.id, company_id: company.id }
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
      get :edit, params: { id: rule.id, company_id: company.id }
      expect(response.status).to eq(200)
    end

    let(:rule2) { FactoryBot.create(:rule, company_id: company_without_access.id) }
    let(:company_without_access) { FactoryBot.create(:company) }
    it 'has a 302 status code' do
      get :edit, params: { id: rule2.id,
                           company_id: company_without_access.id }
      expect(response.status).to eq(302)
    end
  end

  describe 'POST create' do
    it 'creates rule' do
      post :create, params: { rule: { name: 'Any',
                                      company_id: company.id,
                                      allowance_days: 1,
                                      period: 'year' } }
      expect(response).to redirect_to(Rule.last)
    end

    it 'can not creates rule' do
      post :create, params: { rule: { name: nil } }
      expect(response.status).to eq(200)
    end
  end

  describe 'PUT update' do
    it 'updates rule' do
      put :update, params: { rule: { name: 'Other Name' }, id: rule.id }
      expect(rule.reload.name).to eq('Other Name')
      expect(response).to redirect_to(Rule.last)
    end

    it 'can not updates rule' do
      put :update, params: { rule: { name: nil }, id: rule.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes rule' do
      delete :destroy, params: { id: rule.id }
      expect(response).to redirect_to(rules_url)
      expect(Rule.count).to eq(0)
    end
  end
end
