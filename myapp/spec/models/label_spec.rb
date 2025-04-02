require 'rails_helper'

RSpec.describe Label, type: :model do
  let(:user1) { User.create(name: "User1", username: "user1", password: "password123") }
  let(:user2) { User.create(name: "User2", username: "user2", password: "password123") }
  subject { Label.new(name: "Label 1", user: user1) }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a name" do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it "is not valid with the same name" do
    subject.save
    label = Label.new(name: "Label 1", user: user1)
    expect(label).to_not be_valid
  end

  it "is valid with the same name for different users" do
    subject.save
    label = Label.new(name: "Label 1", user: user2)
    expect(label).to be_valid
  end
end
