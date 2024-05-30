# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :model do
  describe "Sign up" do
    context "create a user" do
      let!(:user1) { create(:user1) }
      it "valid" do
        expect(user1).to be_valid
      end
    end

    context "create a user with the same email address" do
      let!(:user1) { User.create(name: "user 1", email: "user@example.com", password: "123") }
      let!(:user2) { User.create(name: "user 2", email: "user@example.com", password: "123") }
      it "not valid" do
        expect(user2).to_not be_valid
      end
    end
  end

  describe "Login" do
    context "Login with a correct information" do
      let!(:user1) { create(:user1) }
      it "valid" do
        expect(User.authenticate("user1@example.com", "123")).to be_valid
      end
    end
    context "Login with a wrong information" do
      let!(:user1) { create(:user1) }
      it "not valid" do
        expect(User.authenticate("user", "123")).to be_nil
      end
    end
  end

  describe "delete" do
    context "delete a user having 3 tasks" do
      let!(:user1) { create(:user1) }
      let!(:user2) { create(:user2) }
      before do
        create(:task1, user_id: user1.id)
        create(:task2, user_id: user1.id)
        create(:task3, user_id: user1.id)
        create(:task4, user_id: user2.id)
      end
      it "tasks deleted" do
        user1.destroy
        expect(Task.count).to eq(1)
      end
    end
  end
end
