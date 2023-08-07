require 'rails_helper'

RSpec.describe Label, type: :model do
  describe "validations" do
    context "when valid" do
      it "is valid with valid attributes" do
        label = build(:label)
        expect(label).to be_valid
      end
    end
    context "when invalid" do
      it "is not valid without a name" do
        label = build(:label, name: nil)
        expect(label).not_to be_valid
        expect(label.errors[:name]).to include("can't be blank")
      end
    end
  end
end
