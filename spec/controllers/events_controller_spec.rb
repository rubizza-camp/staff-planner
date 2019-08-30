# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  render_views

  let(:company) { create(:company) }
  let(:event) { create(:event, company: company, employee: employee) }
  let(:account) { create(:account) }
  let!(:employee) { create(:employee, company: company, account: account) }

  before(:each) do
    sign_in account
    session[:company_id] = company.id
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: { company_id: company.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: { company_id: company.id, rule_id: event.rule.id }
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

    before :each do
      allow_any_instance_of(Events::Create).to receive(:call)
        .and_return(Result::Failure.new(Event.create))
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { company_id: company.id, rule_id: event.rule.id, employee_id: event.employee.id }
        expect(response).to be_successful
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { reason: 'Holidaaaays' }
      end

      before :each do
        allow_any_instance_of(Events::Update).to receive(:call)
          .and_return(Result::Success.new(event))
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
