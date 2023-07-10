# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe 'validaton' do
    it 'create user successfully' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'no error messages when user created successfully' do
      user = build(:user)
      user.valid?
      expect(user.errors).to be_empty
    end

    it 'user cannot be created without name' do
      user = build(:user, name: '')
      expect(user).to be_invalid
    end

    it 'show error messages if name is empty' do
      user = build(:user, name: '')
      user.valid?
      expect(user.errors[:name]).to eq ["can't be blank"]
    end

    it 'user cannot be created with name longer than 255 characters' do
      user = build(:user, name: 'a' * 256)
      expect(user).to be_invalid
    end

    it 'show error messages if name is longer than 255 characters' do
      user = build(:user, name: 'a' * 256)
      user.valid?
      expect(user.errors[:name]).to eq ['is too long (maximum is 255 characters)']
    end

    it 'user cannot be created with description longer than 1000 characters' do
      user = build(:user, description: 'a' * 1001)
      expect(user).to be_invalid
    end

    it 'show error messages if description is longer than 1000 characters' do
      user = build(:user, description: 'a' * 1001)
      user.valid?
      expect(user.errors[:description]).to eq ['is too long (maximum is 1000 characters)']
    end

    it 'user cannot be created without password' do
      user = build(:user, password: nil)
      expect(user).to be_invalid
    end

    it 'show error messages if password is empty' do
      user = build(:user, password: nil)
      user.valid?
      expect(user.errors[:password]).to eq ["can't be blank"]
    end
  end
end
