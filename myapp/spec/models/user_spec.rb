# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation' do
    it 'is valid with valid attributes' do
      user = described_class.new(name: 'user1', email: 'user1@example.com', password: 'password')
      expect(user).to be_valid
    end

    it 'is invalid without name' do
      user = described_class.new(name: nil)
      expect(user).not_to be_valid
    end

    it 'is invalid without email' do
      user = described_class.new(email: nil)
      expect(user).not_to be_valid
    end

    it 'is invalid without password' do
      user = described_class.new(password: nil)
      expect(user).not_to be_valid
    end
  end

  describe 'association' do
    it 'has many tasks' do
      u = described_class.reflect_on_association(:tasks)
      expect(u.macro).to eq(:has_many)
    end
  end
end
