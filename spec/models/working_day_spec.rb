require 'rails_helper'

RSpec.describe WorkingDay do
  let(:company){ create(:company) }

  it 'is valid with valid attributes' do
    working_day = WorkingDay.new( company_id: company.id,
                                  day_of_week: 1)
    expect(working_day).to be_valid
  end

  it 'is invalid with wrong company_id' do
    working_day = WorkingDay.new( company_id: 'wrong_id',
                                  day_of_week: 1)
    expect(working_day).to be_invalid
    expect(working_day.errors.messages).to include(company: ['must exist'])
  end

  it 'is invalid with wrong day_of_week' do
    working_day = WorkingDay.new( company_id: company.id,
                                  day_of_week: -1)
    expect(working_day).to be_invalid
    expect(working_day.errors.messages).to include(day_of_week: ['is not included in the list'])
  end
end
