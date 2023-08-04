require 'rails_helper'

RSpec.describe Label, type: :model do
  context "validations" do
    it "is valid with valid attributes" do
      label = build(:label)
      expect(label).to be_valid
    end

    it "is not valid without a name" do
      label = build(:label, name: nil)
      expect(label).not_to be_valid
      expect(label.errors[:name]).to include("can't be blank")
    end
  end
end
