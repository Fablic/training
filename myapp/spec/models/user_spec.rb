require 'rails_helper'

RSpec.describe User, type: :model do
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

    it 'user cannot be created without username' do
      user = build(:user, username: '')
      expect(user).to be_invalid
    end

    it 'show error messages if username is empty' do
      user = build(:user, username: '')
      user.valid?
      expect(user.errors[:username]).to eq ["can't be blank"]
    end

    it 'user cannot be created with username longer than 255 characters' do
      user = build(:user, username: 'a' * 256)
      expect(user).to be_invalid
    end

    it 'show error messages if username is longer than 255 characters' do
      user = build(:user, username: 'a' * 256)
      user.valid?
      expect(user.errors[:username]).to eq ['is too long (maximum is 255 characters)']
    end
    
    it 'user cannot be created with a username that already exists' do
      create(:user, username: 'ExistingUser')
      user = build(:user, username: 'ExistingUser')
      expect(user).to be_invalid
    end
    
    it 'shows error messages if username already exists' do
      create(:user, username: 'ExistingUser')
      user = build(:user, username: 'ExistingUser')
      user.valid?
      expect(user.errors[:username]).to include('has already been taken')
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
