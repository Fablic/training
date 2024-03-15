require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validaton' do

    context 'when user is created' do
      it 'create user successfully' do
        user = build(:user)
        expect(user).to be_valid
      end
    end
    
    context 'when username is empty' do
      before do
        @user = build(:user, username: '')
      end

      it 'does not create a user' do
        expect(@user).to be_invalid
      end

      it 'shows error messages if username is empty' do
        @user.valid?
        expect(@user.errors[:username]).to include("can't be blank")
      end
    end

    context 'when username is longer than 255 characters' do
      it 'does not create a user' do
        user = build(:user, username: 'a' * 256)
        expect(user).to be_invalid
      end

      it 'shows error messages if username is longer than 255 characters' do
        user = build(:user, username: 'a' * 256)
        user.valid?
        expect(user.errors[:username]).to eq ['is too long (maximum is 255 characters)']
      end
    end

    it 'user cannot be created without password' do
      user = build(:user, password: nil)
      expect(user).to be_invalid
    end

    it 'show error messages if password is empty' do
      user = build(:user, password: nil)
      user.valid?
      expect(user.errors[:password]).to eq ["can't be blank"]
      
    context 'when username exists' do
      it 'does not create a user' do
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
    end

    context 'when password is empty' do
      it 'does not create a user' do
        user = build(:user, password_digest: nil)
        expect(user).to be_invalid
      end

      it 'shows error messages if password_digest is empty' do
        user = build(:user, password_digest: nil)
        user.valid?
        expect(user.errors[:password_digest]).to eq ["can't be blank"]
      end
    end
  end
end
