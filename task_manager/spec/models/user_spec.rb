# frozen_string_literal: true

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
        before { create(:user, email: email) }
        it { is_expected.to_not be_valid }
      end
    end
  end

  describe 'scope' do
    describe 'search_name' do
      subject { User.search_name(name) }
      let(:user1) { create :user, name: 'user_1' }
      let(:user2) { create :user, name: 'user_2' }

      context '何も入れずに検索' do
        let(:name) { '' }
        it { is_expected.to include(user1, user2) }
      end

      context 'nameにパラメーター(user_1)をいれて検索する' do
        let(:name) { 'user_1' }
        it { is_expected.to include(user1) }
      end
    end

    describe 'search_email' do
      subject { User.search_email(email) }
      let(:user1) { create :user, email: 'sample1@sample.com' }
      let(:user2) { create :user, email: 'sample2@sample.com' }

      context '何も入れずに検索' do
        let(:email) { nil }
        it { is_expected.to include(user1, user2) }
      end

      context 'emailにパラメータ(sample1@sample.com)をいれて検索' do
        let(:email) { 'sample1@sample.com' }
        it { is_expected.to include(user1) }
      end
    end
  end

  describe 'function' do
    describe 'will_lose_administrators?' do
      subject { User.will_lose_administrators?(user) }

      context 'adminユーザーを編集する時' do
        let(:user) { create(:admin_user) }
        it { is_expected.to be_truthy }
      end
  
      context '一般ユーザーを編集する時' do
        let(:user) { create(:user) }
        it { is_expected.to be_falsey }
      end
    end

    describe 'only_one_admin?' do
      subject { User.only_one_admin? }

      context 'adminユーザーが一人の時' do
        before { create(:admin_user) }
        it { is_expected.to be_truthy }
      end
  
      context 'adminユーザーが三人の時' do
        before { create_list(:admin_user, 3) }
        it { is_expected.to be_falsey }
      end
    end
  end
end
