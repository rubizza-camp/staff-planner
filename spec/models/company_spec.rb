# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Company, type: :model do
  it 'is valid with valid attributes' do
    company = Company.new(name: 'Company')
    expect(company).to be_valid
  end

  it 'is invalid without name' do
    company = Company.new()
    expect(company).to be_invalid
    expect(company.errors.messages).to include(:name)
  end
end
