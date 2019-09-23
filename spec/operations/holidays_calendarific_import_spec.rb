# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Holidays::CalendarificImport do
  let(:employee) { create(:employee) }
  let(:account)  { employee.account }
  let(:company)  { employee.company }

  describe '#call', vcr: { cassette_name: 'good_response' } do
    context 'with valid params' do
      let(:params) do
        { year: 2020,
          country: 'RU' }
      end

      subject(:call) { Holidays::CalendarificImport.new.call(params, company.id) }

      it 'creates holidays' do
        expect { call }.to change { Holiday.count }.by(31)
      end

      it 'returns success' do
        expect(call).to be_a_kind_of(Result::Success)
      end
    end
  end

  describe '#call', vcr: { cassette_name: 'bad_response' } do
    context 'with invalid country name' do
      let(:params) do
        { year: 2020,
          country: 'ZZ' }
      end

      subject(:call) { Holidays::CalendarificImport.new.call(params, company.id) }

      it 'does not create holidays' do
        expect { call }.to change { Holiday.count }.by(0)
      end

      it 'returns failure' do
        expect(call).to be_a_kind_of(Result::Failure)
      end
    end
  end
end
