# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmployeesController do
  render_views

  let(:company)        { FactoryBot.create(:company) }
  let(:account_owner)  { employee_owner.account }
  let(:employee_owner) { FactoryBot.create(:employee, company: company) }

  let(:account)  { FactoryBot.create(:account, email: '222@mail.ru') }
  let(:employee) { FactoryBot.create(:employee, company: company, account: account) }

  before(:each) do
    sign_in account_owner
  end

  describe 'GET show' do
    it 'has a 200 status code' do
      get :show, params: { company_id: company.id, id: employee.id }
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
      get :edit, params: { company_id: company.id, id: employee.id }
      expect(response.status).to eq(200)
    end

    let(:company_other) { FactoryBot.create(:company) }
    let(:employee_without_access) { FactoryBot.create(:employee, company: company_other, account: account) }
    it 'has a 302 status code' do
      get :edit, params: { company_id: company_other.id, id: employee_without_access.id }
      expect(response.status).to eq(302)
    end
  end

  describe 'POST create' do
    account2 = FactoryBot.build(:account, email: '111@mail.ru')
    it 'creates employeer' do
      post :create, params: { is_enabled: true,
                              position: 'Boss',
                              start_day: '2019-02-02',
                              company_id: company.id,
                              account_id: account.id }
      expect(response.status).to eq(200)
    end

    it 'can not creates employeer' do
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
        company_id: company.id,
        id: employee.id,
        start_day: '2019-02-02',
        position: 'boss'
      }
      expect(response.status).to eq(302)
    end

    it 'can not updates employee' do
      put :update, params: { company_id: company.id, id: employee.id, is_enabled: nil }
      expect(response.status).to eq(302)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes employee' do
      employee
      expect {
        delete :destroy, params: { company_id: company.id, id: employee.id }
      }.to change { Employee.count }.by(-1)

      expect(response).to redirect_to(company_path(company.id))
    end
  end
end
