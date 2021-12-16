require 'rails_helper'

RSpec.describe Task, type: :model do
  subject {
    build(:task)
  }
  it "is valid with all attributes" do
    expect(subject).to be_valid
  end
  it "is not valid without user_id" do
    subject.user_id = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a title" do
    subject.title = nil
    expect(subject).to_not be_valid
  end

  it "is valid without a description" do
    subject.description = nil
    expect(subject).to be_valid
  end

  it "is not valid without a status" do
    subject.status = nil
    expect(subject).to_not be_valid
  end

  it "is not valid with status value not in 0, 1, 2" do
    subject.status = 3
    expect(subject).to_not be_valid
  end

  it "is not valid without a priority" do
    subject.priority = nil
    expect(subject).to_not be_valid
  end

  it "is not valid with priority value not in 0, 1, 2" do
    subject.priority = 3
    expect(subject).to_not be_valid
  end

  it "is valid without due_datetime" do
    subject.due_datetime = nil
    expect(subject).to be_valid
  end

  it "is not valid if not datetime" do
    subject.due_datetime = "not datetime"
    expect(subject).to_not be_valid
  end

  it "is not valid if not correct datetime format" do
    subject.due_datetime = "2020-13-20 13:11:10"
    expect(subject).to_not be_valid
  end
end
