require "rails_helper"

RSpec.describe ControllersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/controllers").to route_to("controllers#index")
    end

    it "routes to #new" do
      expect(get: "/controllers/new").to route_to("controllers#new")
    end

    it "routes to #show" do
      expect(get: "/controllers/1").to route_to("controllers#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/controllers/1/edit").to route_to("controllers#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/controllers").to route_to("controllers#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/controllers/1").to route_to("controllers#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/controllers/1").to route_to("controllers#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/controllers/1").to route_to("controllers#destroy", id: "1")
    end
  end
end
