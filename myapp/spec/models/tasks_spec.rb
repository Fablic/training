# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Tasks", type: :model do
  describe "validation" do
    context "create a task" do
      context "maximum length" do
        let!(:task) { Task.create(title: "X" * 100, description: "Y" * 30000) }
        it "valid" do
          expect(task).to be_valid
        end
      end

      context "empty title" do
        let!(:task_empty_title) { Task.create(title: "") }
        it "no valid" do
          expect(task_empty_title).to_not be_valid
        end
      end

      context "appropriate length title" do
        let!(:task_empty_title) { Task.create(title: "task title") }
        it "valid" do
          expect(task_empty_title).to be_valid
        end
      end

      context "too long title" do
        let!(:task_too_long_title) { Task.create(title: "X" * 110) }
        it "no valid" do
          expect(task_too_long_title).to_not be_valid
        end
      end

      context "empty description" do
        let!(:task_empty_description) { Task.create(title: "X", description: "") }
        it "valid" do
          expect(task_empty_description).to be_valid
        end
      end

      context "appropriate length description" do
        let!(:task_empty_title) { Task.create(title: "X", description: "task description") }
        it "valid" do
          expect(task_empty_title).to be_valid
        end
      end

      context "too long description" do
        let!(:task_empty_description) { Task.create(title: "X", description: "") }
        it "no valid" do
          expect(task_empty_description).to be_valid
        end
      end
    end
  end

  describe "search" do
    context "title" do
      let!(:task1) { Task.create(title: "test title 1") }
      let!(:task2) { Task.create(title: "test title 2") }
      let!(:task3) { Task.create(title: "test title 3") }
      it "find a task with its title 'test title 1'" do
        expect(Task.search_title("1")[0][:title]).to eq "test title 1"
      end
    end
  end

  describe "filter" do
    context "status" do
      let!(:task1) { Task.create(title: "test title 1", status: "not_started") }
      let!(:task2) { Task.create(title: "test title 2", status: "in_progress") }
      let!(:task3) { Task.create(title: "test title 3", status: "completed") }
      it "find a task with its status 'in_progress'" do
        expect(Task.filter_status("in_progress")[0][:status]).to eq "in_progress"
      end
    end
  end
end
