require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  describe "GET index" do
    it "returns http success" do
      get tasks_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET show" do
    let(:task) { create(:task) }

    it "returns http success" do
      get task_path(task)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET new" do
    it "returns http success" do
      get new_task_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET edit" do
    let(:task) { create(:task) }
    
    it "returns http success" do
      get edit_task_path(task)
      expect(response).to have_http_status(:success)
    end
  end
end
