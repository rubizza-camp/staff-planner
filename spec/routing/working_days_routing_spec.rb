require "rails_helper"

RSpec.describe WorkingDaysController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/working_days").to route_to("working_days#index")
    end

    it "routes to #new" do
      expect(:get => "/working_days/new").to route_to("working_days#new")
    end

    it "routes to #show" do
      expect(:get => "/working_days/1").to route_to("working_days#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/working_days/1/edit").to route_to("working_days#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/working_days").to route_to("working_days#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/working_days/1").to route_to("working_days#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/working_days/1").to route_to("working_days#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/working_days/1").to route_to("working_days#destroy", :id => "1")
    end
  end
end
