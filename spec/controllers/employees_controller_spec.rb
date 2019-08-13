# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmployeesController do
  render_views

  describe 'GET show' do
    let(:employee) { create(:employee) }
    let(:account) { create(:account) }

    it 'has a 200 status code' do
      sign_in account
      get :show, params: { company_id: employee.company_id, id: employee.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'GET new' do
    let(:employee) { create(:employee) }
    let(:account) { create(:account) }
    it 'has a 200 status code' do
      sign_in account
      get :new, params: { company_id: employee.company_id }
      expect(response.status).to eq(200)
    end
  end

  describe 'GET edit' do
    let(:employee) { create(:employee) }
    let(:account) { create(:account) }

    it 'has a 200 status code' do
      sign_in account
      get :edit, params: { company_id: employee.company_id, id: employee.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'POST create' do
    let(:company) { create(:company) }
    let(:account) { create(:account) }

    it 'creates employeer' do
      sign_in account
      post :create, params: { is_enabled: true,
                              position: 'Boss',
                              start_day: '2019-02-02',
                              company_id: company.id,
                              account_id: account.id }
      expect(response.status).to eq(200)
    end

    it 'can not creates employeer' do
      account2 = FactoryBot.build(:account, email: '222@mail.ru')
      sign_in account
      post :create, params: { is_enabled: true,
                              position: nil,
                              start_day: '2019-02-02',
                              company_id: company.id,
                              account_id: account2.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'PUT update' do
    let(:employee) { create(:employee)}
    let(:account) { create(:account) }

    it 'updates employee' do
      sign_in account
      put :update, params: {  company_id: employee.company_id, id: employee.id, start_day: '2019-02-02', position: 'boss' }
      expect(response.status).to eq(302)
    end

    it 'can not updates employee' do
      sign_in account
      put :update, params: { company_id: employee.company_id, id: employee.id, is_enabled: nil }
      expect(response.status).to eq(302)
    end
  end

  describe 'DELETE destroy' do
    let(:employee) { create(:employee) }
    let(:account) { create(:account, email: '222@mail.ru') }

    it 'deletes employee' do
      sign_in account
      delete :destroy, params: { company_id: employee.company_id, id: employee.id }
      expect(response).to redirect_to(company_path(employee.company_id))
      expect(Employee.count).to eq(0)
    end
  end
end
