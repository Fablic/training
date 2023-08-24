require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    context 'passes when' do
      it 'is valid with valid attributes' do
        user = build(:user)
        expect(user).to be_valid
      end

      it 'email is saved as lowercase' do
        user = build(:user)
        user.email = 'SAMPLE@SAMPLE.JP'
        user.save!
        expect(user.reload.email).to eq 'sample@sample.jp'
      end
    end

    context 'fails when' do
      shared_examples 'an invalid user' do |attribute, error_message|
        it "without valid #{attribute}" do
          user[attribute] = nil
          expect(user).not_to be_valid
          expect(user.errors[attribute]).to include(error_message)
        end
      end

      let(:user) { build(:user) }

      include_examples 'an invalid user', :first_name, "can't be blank"
      include_examples 'an invalid user', :username, "can't be blank"
      include_examples 'an invalid user', :email, "can't be blank"
      include_examples 'an invalid user', :password_digest, "can't be blank"

      it 'there is duplicate email' do
        user = build(:user)
        user.save
        another_user = build(:user)
        another_user.valid?
        expect(another_user.errors[:email]).to include('has already been taken')
      end

      it 'there is username' do
        user = build(:user)
        user.save
        another_user = build(:user)
        another_user.valid?
        expect(another_user.errors[:username]).to include('has already been taken')
      end

      it 'email is more that 255 characters' do
        user = build(:user)
        user.email = ('a' * 246) + '@sample.jp'
        user.valid?
        expect(user.errors).to be_added(:email, :too_long, count: 255)
      end

      it 'password is less than 8 characters' do
        user = build(:user)
        user.password_digest = '0000000'
        user.valid?
        expect(user.errors).to be_added(:password_digest, :too_short, count: 8)
      end

      it 'email is saved as lowercase' do
        user = build(:user)
        user.email = 'SAMPLE@SAMPLE.JP'
        user.save!
        expect(user.reload.email).not_to eq 'SAMPLE@SAMPLE.JP'
      end
    end
  end
end
