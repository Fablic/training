require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "validations" do
    let(:user) { create(:user) }

    context "when valid" do
      it "is valid with valid attributes" do
        task = build(:task, user: user)
        expect(task).to be_valid
      end
    end
    
    context "when invalid" do
      shared_examples "invalid task" do |attribute|
        it "is not valid without #{attribute}" do
          task = build(:task, attribute => nil, user: user)
          expect(task).not_to be_valid
          expect(task.errors[attribute]).to include("can't be blank")
        end
      end

      include_examples "invalid task", :name
      include_examples "invalid task", :status
      include_examples "invalid task", :priority
    end
  end
end
