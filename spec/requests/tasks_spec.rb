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

  describe "POST create" do
    it "creates a task" do
      expect do
        post tasks_path, params: { task: attributes_for(:task) }
      end.to change(Task, :count).by(1)
    end

    it "returns 302" do
      post tasks_path, params: { task: attributes_for(:task) }
      expect(response).to have_http_status(302)
    end
  end

  describe "PUT update" do
    let(:task) { create(:task) }

    it "updates a task" do
      put task_path(task), params: { task: attributes_for(:task, name: "updated task") }
      expect(task.reload.name).to eq "updated task"
    end

    it "returns 302" do
      put task_path(task), params: { task: attributes_for(:task, name: "updated") }
      expect(response).to have_http_status(302)
    end
  end

  describe "DELETE destroy" do
    let!(:task) { create(:task) }

    it "deletes a task" do
      expect do
        delete task_path(task)
      end.to change(Task, :count).by(-1)
    end

    it "returns 302" do
      delete task_path(task)
      expect(response).to have_http_status(302)
    end
  end
end
