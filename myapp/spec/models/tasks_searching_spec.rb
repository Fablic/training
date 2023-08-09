require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "search_by_name_and_status" do
    # Create a user
    let(:user) { create(:user) }
    # Create tasks with different creation and dealine timestamps for testing sorting
    let!(:task1) { create(:task, name: "Task 1", status: "Not Started", user: user) }
    let!(:task2) { create(:task, name: "Task 2", status: "In Progress", user: user) }
    let!(:task3) { create(:task, name: "Another Task", status: "Done", user: user) }

    it "returns tasks that match the search by name and status" do
      expect(Task.search_by_name_and_status("Task", "In Progress")).to match_array([task2])
    end

    it "returns tasks that match the search by name" do
      expect(Task.search_by_name_and_status("Task 1", nil)).to match_array([task1])
    end

    it "returns tasks that match the search by status" do
      expect(Task.search_by_name_and_status(nil, "Done")).to match_array([task3])
    end

    it "returns all tasks when no search parameters are provided" do
      expect(Task.search_by_name_and_status(nil, nil)).to match_array([task1, task2, task3])
    end
  end
end
