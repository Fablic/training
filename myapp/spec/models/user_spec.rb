require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'normal case' do
    context 'all valid parameters' do
      let(:user) {
        User.new(name: 'hoge',
                 email: 'hoge@hoge.hoge',
                 password: 'password',
                 password_confirmation: 'password')
      }

      it 'has no error' do
        user.valid?
        expect(user.errors.count).to eq 0
      end
    end
  end

  describe 'validation' do
    describe 'name' do
      context 'length is 0' do
        let(:user) {
          User.new(name: '',
                   email: 'hoge@hoge.hoge',
                   password: 'password',
                   password_confirmation: 'password')
        }

        it 'has validation error' do
          user.valid?
          expect(user.errors.count).to eq 1
          expect(user.errors[:name].present?).to be true
        end
      end

      context 'length is 50' do
        let(:user) {
          User.new(name: 'a' * 50,
                   email: 'hoge@hoge.hoge',
                   password: 'password',
                   password_confirmation: 'password')
        }

        it 'has no error' do
          user.valid?
          expect(user.errors.count).to eq 0
        end
      end

      context 'length is 51' do
        let(:user) {
          User.new(name: 'a' * 51,
                   email: 'hoge@hoge.hoge',
                   password: 'password',
                   password_confirmation: 'password')
        }

        it 'has no error' do
          user.valid?
          expect(user.errors.count).to eq 1
          expect(user.errors[:name].present?).to be true
        end
      end
    end

    describe 'email' do
      context 'length is 0' do
        let(:user) {
          User.new(name: 'taro',
                   email: '',
                   password: 'password',
                   password_confirmation: 'password')
        }

        it 'has validation error' do
          user.valid?
          expect(user.errors[:email].present?).to be true
        end
      end

      context 'length is 255' do
        let(:user) {
          User.new(name: 'taro',
                   email: "#{'a' * 248}@ab.com",
                   password: 'password',
                   password_confirmation: 'password')
        }

        it 'has validation error' do
          user.valid?
          expect(user.errors.count).to eq 0
        end
      end

      context 'length is 256' do
        let(:user) {
          User.new(name: 'taro',
                   email: "#{'a' * 249}@ab.com",
                   password: 'password',
                   password_confirmation: 'password')
        }

        it 'has validation error' do
          user.valid?
          expect(user.errors[:email].present?).to be true
        end
      end

      context 'format is valid' do
        let(:user) {
          User.new(name: 'taro',
                   email: 'hoge@hoge.hoge',
                   password: 'password',
                   password_confirmation: 'password')
        }

        it 'has no error' do
          user.valid?
          expect(user.errors.count).to eq 0
        end
      end

      context 'format is invalid' do
        let(:user) {
          User.new(name: 'taro',
                   email: 'hoge',
                   password: 'password',
                   password_confirmation: 'password')
        }

        it 'has no error' do
          user.valid?
          expect(user.errors[:email].present?).to be true
        end
      end

      context 'not unique' do
        let(:user) {
          User.new(name: 'taro',
                   email: 'hoge@hoge.hoge',
                   password: 'password',
                   password_confirmation: 'password')
        }

        before do
          create(:user, email: 'hoge@hoge.hoge')
        end

        it 'has validation error' do
          user.valid?
          expect(user.errors[:email].present?).to be true
        end
      end
    end

    describe 'password' do
      context 'length is 0' do
        let(:user) {
          User.new(name: 'taro',
                   email: 'hoge@hoge.hoge',
                   password: '',
                   password_confirmation: '')
        }

        it 'has validation error' do
          user.valid?
          expect(user.errors[:password].present?).to be true
        end
      end

      context 'length is 7' do
        let(:user) {
          User.new(name: 'taro',
                   email: 'hoge@hoge.hoge',
                   password: 'a' * 7,
                   password_confirmation: 'a' * 7)
        }

        it 'has validation error' do
          user.valid?
          expect(user.errors.count).to eq 1
          expect(user.errors[:password].present?).to be true
        end
      end

      context 'length is 8' do
        let(:user) {
          User.new(name: 'taro',
                   email: 'hoge@hoge.hoge',
                   password: 'a' * 8,
                   password_confirmation: 'a' * 8)
        }

        it 'has no error' do
          user.valid?
          expect(user.errors.count).to eq 0
        end
      end

      context 'password confirmation is wrong' do
        let(:user) {
          User.new(name: 'taro',
                   email: 'hoge@hoge.hoge',
                   password: 'password',
                   password_confirmation: 'password_wrong')
        }

        it 'has no error' do
          user.valid?
          expect(user.errors.count).to eq 1
          expect(user.errors[:password_confirmation].present?).to be true
        end
      end
    end
  end
end
