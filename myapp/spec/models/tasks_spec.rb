# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Tasks", type: :model do
  describe "validation" do
    context "create a task" do
      let!(:user1) { User.create(name: "user 1", email: "user1@example.com", password: "123") }
      context "maximum length" do
        let!(:task) { Task.create(title: "X" * 100, description: "Y" * 30000, user_id: user1[:id]) }
        it "valid" do
          expect(task).to be_valid
        end
      end

      context "empty title" do
        let!(:task_empty_title) { Task.create(title: "", user_id: user1[:id]) }
        it "no valid" do
          expect(task_empty_title).to_not be_valid
        end
      end

      context "appropriate length title" do
        let!(:task_empty_title) { Task.create(title: "task title", user_id: user1[:id]) }
        it "valid" do
          expect(task_empty_title).to be_valid
        end
      end

      context "too long title" do
        let!(:task_too_long_title) { Task.create(title: "X" * 110, user_id: user1[:id]) }
        it "no valid" do
          expect(task_too_long_title).to_not be_valid
        end
      end

      context "empty description" do
        let!(:task_empty_description) { Task.create(title: "X", description: "", user_id: user1[:id]) }
        it "valid" do
          expect(task_empty_description).to be_valid
        end
      end

      context "appropriate length description" do
        let!(:task_empty_title) { Task.create(title: "X", description: "task description", user_id: user1[:id]) }
        it "valid" do
          expect(task_empty_title).to be_valid
        end
      end

      context "too long description" do
        let!(:task_empty_description) { Task.create(title: "X", description: "", user_id: user1[:id]) }
        it "no valid" do
          expect(task_empty_description).to be_valid
        end
      end
    end
  end

  describe "search" do
    let!(:user1) { User.create(name: "user 1", email: "user1@example.com", password: "123") }
    context "title" do
      let!(:task1) { Task.create(title: "test title 1", user_id: user1[:id]) }
      let!(:task2) { Task.create(title: "test title 2", user_id: user1[:id]) }
      let!(:task3) { Task.create(title: "test title 3", user_id: user1[:id]) }
      it "find a task with its title 'test title 1'" do
        expect(Task.search_title("1")[0][:title]).to eq "test title 1"
      end
    end
  end

  describe "filter" do
    let!(:user1) { User.create(name: "user 1", email: "user1@example.com", password: "123") }
    context "status" do
      let!(:task1) { Task.create(title: "test title 1", status: "not_started", user_id: user1[:id]) }
      let!(:task2) { Task.create(title: "test title 2", status: "in_progress", user_id: user1[:id]) }
      let!(:task3) { Task.create(title: "test title 3", status: "completed", user_id: user1[:id]) }
      it "find a task with its status 'in_progress'" do
        expect(Task.filter_status("in_progress")[0][:status]).to eq "in_progress"
      end
    end
  end

  describe "user" do
    context "associated" do
      let!(:user1) { User.create(name: "user 1", email: "user1@example.com", password: "123") }
      let!(:task1) { Task.create(title: "title 1", description: "description 1", user_id: user1[:id]) }
      it "find user 1" do
        expect(task1[:user_id]).to eq user1[:id]
      end
    end
  end
end
