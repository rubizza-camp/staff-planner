# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  render_views

  before(:each) do
    @account = Account.create! valid_attributes
    sign_in @account
  end

  let(:valid_attributes) do
    { name: 'Simon',
      surname: 'Simon',
      email: 'simon@gmail.com',
      password: '123456' }
  end

  let(:invalid_attributes) do
    { name: nil,
      surname: 'Simon',
      email: 'simon@gmail.com',
      password: '12' }
  end

  let(:valid_session) { {} }

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: @account.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit, params: { id: @account.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { name: 'Sime',
          surname: 'Sime' }
      end

      it 'updates the requested account' do
        put :update, params: { id: @account.to_param, account: new_attributes }, session: valid_session
        @account.reload
        expect(@account.name).to include('Sime')
        expect(@account.surname).to include('Sime')
      end

      it 'redirects to the account' do
        put :update, params: { id: @account.to_param, account: valid_attributes }, session: valid_session
        expect(response).to redirect_to(@account)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested account' do
      expect do
        delete :destroy, params: { id: @account.to_param }, session: valid_session
      end.to change(Account, :count).by(-1)
    end

    it 'redirects to the accounts list' do
      delete :destroy, params: { id: @account.to_param }, session: valid_session
      expect(response).to redirect_to(root_path)
    end
  end
end
