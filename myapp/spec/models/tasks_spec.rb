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
end
