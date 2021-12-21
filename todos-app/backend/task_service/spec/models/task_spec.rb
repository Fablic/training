require 'rails_helper'

RSpec.describe Task, type: :model do
  subject {
    build(:task)
  }

  context "with all attributes" do
    it "is valid" do
      expect(subject).to be_valid
    end
  end

  context "without user_id" do
    it "is invalid" do
      subject.user_id = nil
      expect(subject).to_not be_valid
    end
  end

  context "without a title" do
    it "is invalid" do
      subject.title = nil
      expect(subject).to_not be_valid
    end
  end

  context "without a description" do
    it "is valid" do
      subject.description = nil
      expect(subject).to be_valid
    end
  end

  context "without a status" do
    it "is not valid" do
      subject.status = nil
      expect(subject).to_not be_valid
    end
  end

  context "when status not in 0, 1, 2" do
    it "is invalid" do
      expect{subject.status = 3}.to raise_error(ArgumentError)
    end
  end

  context "without a priority" do
    it "is invalid" do
      subject.priority = nil
      expect(subject).to_not be_valid
    end
  end

  context "when priority not in 0, 1, 2" do
    it "is invalid" do
      expect{subject.priority = 3}.to raise_error(ArgumentError)
    end
  end

  context "without due_datetime" do
    it "is valid" do
      subject.due_datetime = nil
      expect(subject).to be_valid
    end
  end

  context "when due_datetime is not datetime" do
    it "is invalid" do
      subject.due_datetime = "not datetime"
      expect(subject).to_not be_valid
    end
  end

  context "when due_datetime not in correct datetime format" do
    it "is invalid" do
      subject.due_datetime = "2020-13-20 13:11:10"
      expect(subject).to_not be_valid
    end
  end
end
