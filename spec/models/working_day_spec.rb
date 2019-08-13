# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkingDay do
  context 'with valid attributess' do
    let(:working_day) { create(:working_day) }

    it 'is valid' do
      expect(working_day).to be_valid
    end
  end

  context 'with wrong company_id' do
    let(:working_day) { build(:working_day, company_id: 'wrong_id') }

    it 'is invalid' do
      expect(working_day).to be_invalid
      expect(working_day.errors.messages).to include(company: ['must exist'])
    end
  end

  context 'with wrong day_of_week' do
    let(:working_day) { build(:working_day, day_of_week: -1) }

    it 'is invalid' do
      expect(working_day).to be_invalid
      expect(working_day.errors.messages).to include(day_of_week: ['is not included in the list'])
    end
  end
end
