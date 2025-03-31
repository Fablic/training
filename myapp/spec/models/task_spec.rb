require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { User.create(name: "Test User", username: "testuser", password: "password123") }
  subject { Task.new(name: "Task 1", deadline: 1.day.from_now, priority: "low", status: "to_do", user: user) }
      
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end
  
    it "is not valid without a name" do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it "is not valid with a name longer than 256 characters" do
      subject.name = "a" * 257
      expect(subject).to be_invalid
      expect(subject.errors[:name]).to include(I18n.t("errors.messages.too_long"))
    end
  
    it "is not valid without a priority" do
      subject.priority = nil
      expect(subject).to_not be_valid
    end
  
    it "is not valid without a status" do
      subject.status = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a deadline" do
      subject.deadline = nil
      expect(subject).to_not be_valid
    end

    it "is not valid when the deadline is in the past" do
      subject.deadline = Time.current - 1.day
      expect(subject).to be_invalid
      expect(subject.errors[:deadline]).to include(I18n.t("errors.messages.deadline_in_past"))
    end
end
