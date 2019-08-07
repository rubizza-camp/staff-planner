# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Employees', type: :request do
  describe 'GET /employees' do
    it 'works! (now write some real specs)' do
      company = Company.new(name: 'Company')
      company.save
      get company_employees_path(company_id: company.id)
      expect(response).to have_http_status(200)
    end
  end
end
