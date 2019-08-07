# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmployeesController do
  render_views

  describe 'GET index' do
    let(:employee) { create(:employee)}

    it 'has a 200 status code' do
      get :index, params: { company_id: employee.company_id }
      expect(response.status).to eq(200)
    end
  end

  describe 'GET show' do
    let(:employee) { create(:employee) }

    it 'has a 200 status code' do
      get :show, params: { company_id: employee.company_id, id: employee.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'GET new' do
    let(:employee) { create(:employee) }
    it 'has a 200 status code' do
      get :new, params: { company_id: employee.company_id }
      expect(response.status).to eq(200)
    end
  end

  describe 'GET edit' do
    let(:employee) { create(:employee) }

    it 'has a 200 status code' do
      get :edit, params: { company_id: employee.company_id, id: employee.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'POST create' do
    let(:company) { create(:company) }
    let(:account) { create(:account) }

    it 'creates employeer' do
      post :create, params: { is_enabled: true,
                              position: 'Boss',
                              start_day: '2019-02-02',
                              company_id: company.id,
                              account_id: account.id }
      expect(response.status).to eq(200)
    end

    it 'can not creates employeer' do
      post :create, params: { is_enabled: true,
                              position: nil,
                              start_day: '2019-02-02',
                              company_id: company.id,
                              account_id: account.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'PUT update' do
    let(:employee) { create(:employee)}

    it 'updates employee' do
      put :update, params: { company_id: employee.company_id, id: employee.id, is_enabled: false }
      expect(response.status).to eq(200)
    end

    it 'can not updates employee' do
      put :update, params: { company_id: employee.company_id, id: employee.id, is_enabled: nil }
      expect(response.status).to eq(200)
    end
  end

  describe 'DELETE destroy' do
    let(:employee) { create(:employee) }

    it 'deletes employee' do
      delete :destroy, params: { company_id: employee.company_id, id: employee.id }
      expect(response).to redirect_to(company_employees_url)
      expect(Employee.count).to eq(0)
    end
  end
end
