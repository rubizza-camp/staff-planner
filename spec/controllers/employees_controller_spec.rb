# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmployeesController do
  render_views

  before(:each) do
    @account = FactoryBot.create(:account, email: '222@mail.ru')
    @employee = FactoryBot.create(:employee)
    sign_in @account
  end

  describe 'GET index' do
    let(:employee) { create(:employee) }

    it 'has a 200 status code' do
      get :index, params: { company_id: @employee.company_id }
      expect(response.status).to eq(200)
    end

  describe 'GET show' do
    it 'has a 200 status code' do
      get :show, params: { company_id: @employee.company_id, id: @employee.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'GET new' do
    it 'has a 200 status code' do
      get :new, params: { company_id: @employee.company_id }
      expect(response.status).to eq(200)
    end
  end

  describe 'GET edit' do
    it 'has a 200 status code' do
      get :edit, params: { company_id: @employee.company_id, id: @employee.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'POST create' do
    it 'creates employeer' do
      company = FactoryBot.create(:company)
      post :create, params: { is_enabled: true,
                              position: 'Boss',
                              start_day: '2019-02-02',
                              company_id: company.id,
                              account_id: @account.id }
      expect(response.status).to eq(200)
    end

    it 'can not creates employeer' do
      company = FactoryBot.create(:company)
      account2 = FactoryBot.build(:account, email: '111@mail.ru')
      post :create, params: { is_enabled: true,
                              position: nil,
                              start_day: '2019-02-02',
                              company_id: company.id,
                              account_id: account2.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'PUT update' do
    it 'updates employee' do
      put :update, params: {
        company_id: @employee.company_id,
        id: @employee.id,
        start_day: '2019-02-02',
        position: 'boss'
      }
      expect(response.status).to eq(302)
    end

    it 'can not updates employee' do
      put :update, params: { company_id: @employee.company_id, id: @employee.id, is_enabled: nil }
      expect(response.status).to eq(302)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes employee' do
      delete :destroy, params: { company_id: @employee.company_id, id: @employee.id }
      expect(response).to redirect_to(company_path(@employee.company_id))
      expect(Employee.count).to eq(0)
    end
  end
end
