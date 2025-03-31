require 'rails_helper'

RSpec.describe User, type: :model do
  subject { User.new(name: "User 1", username: "user1", password: "12345678") }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a name" do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a username" do
    subject.username = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a password" do
    subject.password = nil
    expect(subject).to_not be_valid
  end

  it "is not valid with a password shorter than 8 characters" do
    subject.password = "1234567"
    expect(subject).to be_invalid
    expect(subject.errors[:password]).to include(I18n.t("errors.messages.too_short", count: 8))
  end
end
