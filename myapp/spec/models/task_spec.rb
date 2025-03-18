require 'rails_helper'

RSpec.describe Task, type: :model do
  subject { Task.new(name: "Task 1", deadline: 1.day.from_now, priority: "low", status: "to do") }
      
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end
  
    it "is not valid without a name" do
      subject.name = nil
      expect(subject).to_not be_valid
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
end
