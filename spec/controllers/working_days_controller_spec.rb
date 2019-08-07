require "rails_helper"

RSpec.describe WorkingDaysController do
  render_views

  describe "GET index" do
    let!(:working_day){ create(:working_day) }

    it "has a 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe "GET show" do
    let(:working_day){ create(:working_day) }

    it "has a 200 status code" do
      get :show, params: { id: working_day.id }
      expect(response.status).to eq(200)
    end
  end

  describe "GET new" do
    it "has a 200 status code" do
      get :new
      expect(response.status).to eq(200)
    end
  end

  describe "GET edit" do
    let(:working_day){ create(:working_day) }

    it "has a 200 status code" do
      get :edit, params: { id: working_day.id }
      expect(response.status).to eq(200)
    end
  end

  describe "POST create" do
    it "creates working_day" do
      company_id = Company.create(name: 'MyCompany').id
      post :create, params: { working_day: { company_id: company_id,
                                             day_of_week: 1 } }
      expect(response).to redirect_to(WorkingDay.last)
    end

    it "can not creates working_day" do
      company_id = Company.create(name: 'MyCompany').id
      post :create, params: { working_day: { company_id: company_id,
                                             day_of_week: 0 } }
      expect(response.status).to eq(200)
    end
  end

  describe "PUT update" do
    let(:working_day){ create(:working_day) }

    it "updates working_day" do
      put :update, params: { working_day: { day_of_week: 2 }, id: working_day.id }
      expect(working_day.reload.day_of_week).to eq(2)
      expect(response).to redirect_to(WorkingDay.last)
    end

    it "can not updates working_day" do
      put :update, params: { working_day: { day_of_week: 0 }, id: working_day.id }
      expect(response.status).to eq(200)
    end
  end

  describe "DELETE destroy" do
    let(:working_day){ create(:working_day) }

    it "deletes working_day" do
      delete :destroy, params: { id: working_day.id }
      expect(response).to redirect_to(working_days_url)
      expect(WorkingDay.count).to eq(0)
    end
  end
end
