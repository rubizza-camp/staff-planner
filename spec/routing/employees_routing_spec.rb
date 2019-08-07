# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmployeesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: 'companies/1/employees').to route_to('employees#index', company_id: '1')
    end

    it 'routes to #new' do
      expect(get: 'companies/1/employees/new').to route_to('employees#new', company_id: '1')
    end

    it 'routes to #show' do
      expect(get: 'companies/1/employees/1').to route_to('employees#show', id: '1', company_id: '1')
    end

    it 'routes to #edit' do
      expect(get: 'companies/1/employees/1/edit').to route_to('employees#edit', id: '1', company_id: '1')
    end

    it 'routes to #create' do
      expect(post: 'companies/1/employees').to route_to('employees#create', company_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: 'companies/1//employees/1').to route_to('employees#update', id: '1', company_id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: 'companies/1//employees/1').to route_to('employees#update', id: '1', company_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: 'companies/1//employees/1').to route_to('employees#destroy', id: '1', company_id: '1')
    end
  end
end
