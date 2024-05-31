# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Tasks", type: :model do
  describe "validation" do
    context "create a task" do
      let!(:user1) { create(:user1) }
      context "maximum length" do
        let!(:task) { create(:task1, user_id: user1.id) }
        it "valid" do
          expect(task).to be_valid
        end
      end

      context "empty title" do
        let!(:task_empty_title) { Task.create(title: "", user_id: user1.id) }
        it "no valid" do
          expect(task_empty_title).to_not be_valid
        end
      end

      context "appropriate length title" do
        let!(:task) { create(:task1, user_id: user1.id) }
        it "valid" do
          expect(task).to be_valid
        end
      end

      context "too long title" do
        let!(:task_too_long_title) { Task.create(title: "X" * 110, user_id: user1.id) }
        it "no valid" do
          expect(task_too_long_title).to_not be_valid
        end
      end

      context "empty description" do
        let!(:task_empty_description) { create(:task_empty_description, user_id: user1.id) }
        it "valid" do
          expect(task_empty_description).to be_valid
        end
      end

      context "too long description" do
        let!(:task_too_long_description) { Task.create(title: "X", description: "Y" * 30010, user_id: user1.id) }
        it "no valid" do
          expect(task_too_long_description).to_not be_valid
        end
      end
    end
  end

  describe "search" do
    let!(:user1) { create(:user1) }
    context "title" do
      let!(:task1) { create(:task1, user_id: user1.id) }
      let!(:task2) { create(:task2, user_id: user1.id) }
      let!(:task3) { create(:task3, user_id: user1.id) }
      it "find a task with its title 'test title 1'" do
        expect(Task.search_title("1")[0].title).to eq "test title 1"
      end
    end
  end

  describe "filter" do
    let!(:user1) { create(:user1) }
    context "status" do
      let!(:task1) { create(:task1, user_id: user1.id) }
      let!(:task2) { create(:task2, user_id: user1.id) }
      let!(:task3) { create(:task3, user_id: user1.id) }
      it "find a task with its status 'in_progress'" do
        expect(Task.filter_status("in_progress")[0].status).to eq "in_progress"
      end
    end
  end

  describe "user" do
    context "associated" do
      let!(:user1) { create(:user1) }
      let!(:task1) { create(:task1, user_id: user1.id) }
      it "find user 1" do
        expect(task1.user_id).to eq user1.id
      end
    end
  end
end
