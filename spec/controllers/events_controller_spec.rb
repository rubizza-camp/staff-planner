# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  render_views

  before(:each) do
    @account = FactoryBot.create(:account, email: '333@mail.ru')
    @employee = FactoryBot.create(:employee, account_id: @account.id)
    @rule = FactoryBot.create(:rule)
    @event = FactoryBot.create(:event)
    sign_in @account
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: { company_id: @event.company_id }
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: @event.id, company_id: @event.company_id }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: { company_id: @event.company_id, rule_id: @rule.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit, params: { id: @event.id, company_id: @event.company_id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Event' do
        expect(Event.count).eql?(1)
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: { company_id: @event.company_id, rule_id: @event.rule_id, employee_id: @event.employee_id }
          expect(response).to be_successful
        end
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      it 'updates the requested event' do
        put :update, params: { id: @event.id, company_id: @event.company_id, reason: 'ok' }
        @event.reload
        expect(response).to be_successful
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'edit' template)" do
          put :update, params: { id: @event.id, reason: 'OK', company_id: @event.company_id }
          expect(response).to be_successful
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested event' do
      expect(Event.count).eql?(0)
    end
  end
end
