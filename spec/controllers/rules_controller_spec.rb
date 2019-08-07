require "rails_helper"

RSpec.describe RulesController do
  render_views

  describe "GET index" do
    let!(:rule){ create(:rule) }

    it "has a 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe "GET show" do
    let(:rule){ create(:rule) }

    it "has a 200 status code" do
      get :show, params: { id: rule.id }
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
    let(:rule){ create(:rule) }

    it "has a 200 status code" do
      get :edit, params: { id: rule.id }
      expect(response.status).to eq(200)
    end
  end

  describe "POST create" do
    it "creates rule" do
      company_id = Company.create(name: 'MyCompany').id
      post :create, params: { rule: { name: "Any",
                                      company_id: company_id,
                                      alowance_days: 1,
                                      period: 'year' } }
      expect(response).to redirect_to(Rule.last)
    end

    it "can not creates rule" do
      post :create, params: { rule: { name: nil } }
      expect(response.status).to eq(200)
    end
  end

  describe "PUT update" do
    let(:rule){ create(:rule) }

    it "updates rule" do
      put :update, params: { rule: { name: "Other Name" }, id: rule.id }
      expect(rule.reload.name).to eq('Other Name')
      expect(response).to redirect_to(Rule.last)
    end

    it "can not updates rule" do
      put :update, params: { rule: { name: nil }, id: rule.id }
      expect(response.status).to eq(200)
    end
  end

  describe "DELETE destroy" do
    let(:rule){ create(:rule) }

    it "deletes rule" do
      delete :destroy, params: { id: rule.id }
      expect(response).to redirect_to(rules_url)
      expect(Rule.count).to eq(0)
    end
  end
end
