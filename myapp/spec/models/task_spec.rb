require 'rails_helper'

RSpec.describe Task, type: :model do
  before do
    @user = create(:user)
  end
  describe "validations" do
    context "when valid" do
      it "is valid with valid attributes" do
        task = build(:task)
        expect(task).to be_valid
      end
    end
    context "when invalid" do
      it "is not valid without a name" do
        task = build(:task, name: nil)
        expect(task).not_to be_valid
        expect(task.errors[:name]).to include("can't be blank")
      end

      it "is not valid without a status" do
        task = build(:task, status: nil)
        expect(task).not_to be_valid
        expect(task.errors[:status]).to include("can't be blank")
      end

      it "is not valid without a priority" do
        task = build(:task, priority: nil)
        expect(task).not_to be_valid
        expect(task.errors[:priority]).to include("can't be blank")
      end
    end
  end
end
