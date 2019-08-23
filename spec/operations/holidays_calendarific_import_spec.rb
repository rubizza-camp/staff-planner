# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Holidays::CalendarificImport do
  let(:employee) { create(:employee) }
  let(:account)  { employee.account }
  let(:company)  { employee.company }
  describe '#call', :vcr => {:cassette_name => 'good_response',
                             :record => :new_episodes
  } do
    context 'with valid params' do
      let(:params) { { company_id: company.id,
                       year: 2020,
                       country: 'RU'
      } }

      subject(:call) { Holidays::CalendarificImport.new.call(params) }
      
      it 'creates holidays' do
        expect { call }.to change { Holiday.count }.by(31)
      end

      it 'returns success' do
        expect(call).to be_a_kind_of(Result::Success)
      end
    end
  end
  describe '#call', :vcr => {:cassette_name => 'bad_response',
                             :record => :new_episodes
  } do
    context 'with invalid country name' do
      let(:params) { { company_id: 1,
                       year: 2020,
                       country: 'ZZ'
      } }

      subject(:call) { Holidays::CalendarificImport.new.call(params) }

      it 'does not create holidays' do
        expect { call }.to change { Holiday.count }.by(0)
      end

      it 'returns failure' do
        expect(call).to be_a_kind_of(Result::Failure)
      end
    end
  end
end
