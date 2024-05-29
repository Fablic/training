# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "validation" do
    context "create a user" do
      let!(:user1) { User.create(name: "user 1", email: "user1@example.com", password: "123") }
      it "valid" do
        expect(user1).to be_valid
      end
      context "empty name" do
        let!(:user1) { User.create(name: "", email: "user1@example.com", password: "123") }
        it "no valid" do
          expect(user1).to_not be_valid
        end
      end
    end
  end
end
