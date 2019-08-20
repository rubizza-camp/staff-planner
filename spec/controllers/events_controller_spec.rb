# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  render_views

  let(:company) { FactoryBot.create(:company) }
  let(:event) { FactoryBot.create(:event, company_id: company.id, employee_id: employee.id) }
  let(:account) { FactoryBot.create(:account) }
  let!(:employee) { FactoryBot.create(:employee, company_id: company.id, account_id: account.id) }

  before(:each) do
    sign_in account
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: { company_id: company.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: { company_id: company.id, rule_id: event.rule_id }
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit, params: { id: event.id, company_id: company.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Event' do
        expect(Event.count).eql?(1)
      end
    end

    # TO DO WITH INVALID PARAMETERS
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { reason: 'Holidaaaays' }
      end

      it 'updates the requested account' do
        put :update, params: { id: event.id, company_id: company.id, event: new_attributes }
        event.reload
        expect(event.reason).eql?('Holidaaaays')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested event' do
      expect(Event.count).eql?(0)
    end
  end
end
