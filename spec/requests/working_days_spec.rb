require 'rails_helper'

RSpec.describe "WorkingDays", type: :request do
  describe "GET /working_days" do
    it "works! (now write some real specs)" do
      get company_working_day_path
      expect(response).to have_http_status(200)
    end
  end
end
