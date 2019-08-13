require "rails_helper"

RSpec.describe HolidaysController do
  render_views

  describe "GET index" do
    let!(:holiday){ create(:holiday) }

    it "has a 200 status code" do
      get :index, params: { company_id: holiday.company_id }
      expect(response.status).to eq(200)
    end
  end

  describe "GET show" do
    let(:holiday){ create(:holiday) }

    it "has a 200 status code" do
      get :show, params: { id: holiday.id,
                           company_id: holiday.company_id }
      expect(response.status).to eq(200)
    end
  end

  describe "GET new" do
    let(:company){ create(:company) }

    it "has a 200 status code" do
      get :new, params: { company_id: company.id }
      expect(response.status).to eq(200)
    end
  end

  describe "GET edit" do
    let(:holiday){ create(:holiday) }

    it "has a 200 status code" do
      get :edit, params: { id: holiday.id,
                           company_id: holiday.company_id }
      expect(response.status).to eq(200)
    end
  end

  describe "POST create" do
    let(:company){ create(:company) }

    it "creates holiday" do
      post :create, params: { holiday: { date: Date.today + 1,
                                         name: 'Lengaz' },
                              company_id: company.id  }
      expect(response).to redirect_to company_holidays_url
    end

    it "can not creates holiday" do
      post :create, params: { holiday: { date: Date.today - 1 },
                              company_id: company.id  }
      expect(response.status).to eq(200)
    end
  end

  describe "PUT update" do
    let(:holiday){ create(:holiday) }

    it "updates holiday" do
      put :update, params: { holiday: { date: Date.today + 7 },
                             id: holiday.id,
                             company_id: holiday.company_id }
      expect(holiday.reload.date).to eq( Date.today + 7 )
      expect(response).to redirect_to company_holidays_url
    end

    it "can not updates holiday" do
      put :update, params: { holiday: { date: Date.today - 7 },
                             id: holiday.id,
                             company_id: holiday.company_id }
      expect(response.status).to eq(200)
    end
  end

  describe "DELETE destroy" do
    let(:holiday){ create(:holiday) }

    it "deletes holiday" do
      delete :destroy, params: { id: holiday.id,
                                 company_id: holiday.company_id }
      expect(response).to redirect_to(company_holidays_url)
      expect(Holiday.count).to eq(0)
    end
  end
end
