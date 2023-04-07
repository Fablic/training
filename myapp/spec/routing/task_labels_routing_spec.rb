require "rails_helper"

RSpec.describe TaskLabelsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/task_labels").to route_to("task_labels#index")
    end

    it "routes to #new" do
      expect(get: "/task_labels/new").to route_to("task_labels#new")
    end

    it "routes to #show" do
      expect(get: "/task_labels/1").to route_to("task_labels#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/task_labels/1/edit").to route_to("task_labels#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/task_labels").to route_to("task_labels#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/task_labels/1").to route_to("task_labels#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/task_labels/1").to route_to("task_labels#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/task_labels/1").to route_to("task_labels#destroy", id: "1")
    end
  end
end
