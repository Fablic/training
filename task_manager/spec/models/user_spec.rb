require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation' do
    let(:name) { 'taro' }
    let(:email) { 'taro@taro.com' }
    let(:password) { 'password' }
    let(:password_confirmation) { 'password' }
    subject { build(:user, name: name, email: email, password: password, password_confirmation: password_confirmation) }

    context '登録可能な形式' do
      it { is_expected.to be_valid }
    end

    describe 'name' do
      context 'nameが空の場合に登録できない' do
        let(:name) { nil }
        it { is_expected.to_not be_valid }
      end

      context 'nameが50文字を超えた場合' do
        let(:name) { 'a' * 51 }
        it { is_expected.to_not be_valid }
      end
    end

    describe 'email' do
      context 'emailが空の場合' do
        let(:email) { nil }
        it { is_expected.to_not be_valid }
      end

      context 'emailが255文字を超えた場合' do
        let(:email) { 'a' * 255 }
        it { is_expected.to_not be_valid }
      end

      context '形式が違う場合' do
        let(:email) { 'a' }
        it { is_expected.to_not be_valid }
      end

      context 'emailが255文字を超えた場合' do
        let(:email) { 'a' * 255 }
        it { is_expected.to_not be_valid }
      end

      context '重複したメールアドレスの場合' do
        before{ create(:user, email: email) }
        it { is_expected.to_not be_valid }
      end
    end
  end
end
