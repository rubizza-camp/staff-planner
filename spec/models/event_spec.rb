require 'rails_helper'

RSpec.describe Event, type: :model do
  context 'with valid attributes' do
    let(:event){ create(:event) }

  	it 'is valid' do
    	expect(event).to be_valid
  	end
	end

	context 'without start_period' do
    let(:event){ create(:event, start_period: '') }

  	it 'is valid' do
    	expect(event).to be_invalid
    	expect(event.errors.messages).to include(:start_period)
  	end
	end

	context 'with wrong period type' do
    let(:event){ build_stubbed(:event, end_period: 'text', start_period: 'text') }

  	it 'is valid' do
    	expect(event).to be_invalid
    	expect(event.errors.messages).to include(:start_period,:end_period)
  	end
	end

	context 'without end_period' do
    let(:event){ build(:event, end_period: :null) }

  	it 'is valid' do
    	expect(event).to be_invalid
    	expect(event.errors.messages).to include(:end_period)
  	end
	end


	context 'without employee_id' do
    let(:event){ build(:event) }

  	it 'is valid' do
  		byebug
    	expect(event).to be_invalid
    	expect(event.errors.messages).to include(:employee_id)
  	end
	end


	context 'without rule_id' do
    let(:event){ build(:event, rule_id: :null) }

  	it 'is valid' do
    	expect(event).to be_invalid
    	expect(event.errors.messages).to include(:rule_id)
  	end
	end
end
