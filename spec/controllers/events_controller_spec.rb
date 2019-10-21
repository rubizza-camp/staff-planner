# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  render_views

  let(:company) { create(:company) }
  let(:event) { create(:event, company: company, employee: employee) }
  let(:account) { create(:account) }
  let!(:employee) { create(:employee, company: company, account: account) }
  let!(:rule) { create(:rule, company: company) }

  before(:each) do
    sign_in account
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: { employee_id: employee.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: { start_period: Date.today }
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit, params: { id: event.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Event' do
        post :create, params: { event: { start_day: Date.today,
                                         first_period: 'Morning',
                                         end_day: Date.today,
                                         second_period: 'End of day',
                                         rule_id: rule.id,
                                         reason: 'any reason',
                                         employee_id: employee.id } }
        expect(Event.count).to be(1)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { event: { start_day: Date.today,
                                         first_period: 'Morning',
                                         end_day: Date.today,
                                         second_period: 'End of day',
                                         employee_id: employee.id,
                                         state: 'wrong state' } }
        expect(response).to be_successful
        expect(Event.count).to be(0)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      it 'updates the requested account' do
        put :update, params: { event: { start_day: Date.today,
                                        first_period: 'Morning',
                                        end_day: Date.today,
                                        second_period: 'End of day',
                                        rule_id: rule.id,
                                        reason: 'Holidaaaays',
                                        employee_id: employee.id },
                               id: event.id }
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
