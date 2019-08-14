# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Holiday do
  context 'with valid attributess' do
    let(:holiday) { create(:holiday) }

    it 'is valid' do
      expect(holiday).to be_valid
    end
  end

  context 'with blank name' do
    let(:holiday) { build(:holiday, name: '') }

    it 'is invalid' do
      expect(holiday).to be_invalid
      expect(holiday.errors.messages).to include(name: ['can\'t be blank'])
    end
  end

  context 'with wrong company_id' do
    let(:holiday) { build(:holiday, company_id: 'wrong_id') }

    it 'is invalid' do
      expect(holiday).to be_invalid
      expect(holiday.errors.messages).to include(company: ['must exist'])
    end
  end

  context 'with wrong holiday date' do
    let(:holiday) { build(:holiday, date: Date.today - 1) }

    it 'is invalid' do
      expect(holiday).to be_invalid
      expect(holiday.errors.messages).to include(date: ['Can\'t be in the past'])
    end
  end
end
