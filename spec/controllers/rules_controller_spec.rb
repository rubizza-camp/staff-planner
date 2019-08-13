# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RulesController do
  render_views

  before(:each) do
    @rule = FactoryBot.create(:rule) 
    account = FactoryBot.create(:account) 
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
      get :show, params: { id: @rule.id }
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
      get :edit, params: { id: @rule.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'POST create' do
    it 'creates rule' do
      company_id = Company.create(name: 'MyCompany').id
      post :create, params: { rule: { name: 'Any',
                                      company_id: company_id,
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
      put :update, params: { rule: { name: 'Other Name' }, id: @rule.id }
      expect(@rule.reload.name).to eq('Other Name')
      expect(response).to redirect_to(Rule.last)
    end

    it 'can not updates rule' do
      put :update, params: { rule: { name: nil }, id: @rule.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes rule' do
      delete :destroy, params: { id: @rule.id }
      expect(response).to redirect_to(rules_url)
      expect(Rule.count).to eq(0)
    end
  end
end
