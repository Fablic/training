# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation' do
    subject { build(:admin_user, params) }
    let(:params) { { username: username, email: email, icon: icon, role: role, password_digest: password_digest } }

    describe 'valid' do
      context 'valid all property' do
        let(:username) { 'admin-user' }
        let(:email) { 'admin-user@example.com' }
        let(:role) { :admin }
        let(:icon) { nil }
        let(:password_digest) { 'xxxxyyyy1234' }

        it { is_expected.to be_valid }
      end

      context 'valid role' do
        let(:username) { 'normal-user' }
        let(:email) { 'normal-user@example.com' }
        let(:role) { :normal }
        let(:icon) { nil }
        let(:password_digest) { 'xxxxyyyy1234' }

        it { is_expected.to be_valid }
      end

      context 'valid icon' do
        let(:username) { 'admin-user' }
        let(:email) { 'admin-user@example.com' }
        let(:role) { :admin }
        let(:icon) { 'https://xxx.yyy.com' }
        let(:password_digest) { 'xxxxyyyy1234' }

        it { is_expected.to be_valid }
      end
    end

    describe 'invalid' do
      context 'invalid username nil' do
        let(:username) { nil }
        let(:email) { 'admin-user@example.com' }
        let(:role) { :admin }
        let(:icon) { nil }
        let(:password_digest) { 'xxxxyyyy1234' }

        it { is_expected.to_not be_valid }
      end

      context 'invalid username length' do
        let(:username) { Faker::Alphanumeric.alpha(number: 21) }
        let(:email) { 'admin-user@example.com' }
        let(:role) { :admin }
        let(:icon) { nil }
        let(:password_digest) { 'xxxxyyyy1234' }

        it { is_expected.to_not be_valid }
      end

      context 'invalid username is duplicate' do
        let!(:exist_user) { create(:admin_user) }
        let!(:duplicate_user) { build(:normal_user, username: 'admin') }

        it 'cannot save record' do
          expect(duplicate_user.save).to eq(false)
        end
      end

      context 'invalid email nil' do
        let(:username) { 'admin-user' }
        let(:email) { nil }
        let(:role) { :admin }
        let(:icon) { nil }
        let(:password_digest) { 'xxxxyyyy1234' }

        it { is_expected.to_not be_valid }
      end

      context 'invalid email length' do
        let(:username) { "#{Faker::Alphanumeric.alpha(number: 248)}@a.com" }
        let(:email) { 'admin-user@example.com' }
        let(:role) { :admin }
        let(:icon) { nil }
        let(:password_digest) { 'xxxxyyyy1234' }

        it { is_expected.to_not be_valid }
      end

      context 'invalid email is duplicate' do
        let!(:exist_user) { create(:admin_user) }
        let!(:duplicate_user) { build(:normal_user, email: 'admin@a.com') }

        it 'cannot save record' do
          expect(duplicate_user.save).to eq(false)
        end
      end

      context 'invalid email regex error' do
        let(:username) { 'admin-user' }
        let(:email) { 'admin-user@admin' }
        let(:role) { :admin }
        let(:icon) { nil }
        let(:password_digest) { 'xxxxyyyy1234' }

        it { is_expected.to_not be_valid }
      end

      context 'invalid icon length' do
        let(:username) { 'admin-user' }
        let(:email) { 'admin-user@example.com' }
        let(:role) { :admin }
        let(:icon) { Faker::Alphanumeric.alpha(number: 5001) }
        let(:password_digest) { 'xxxxyyyy1234' }

        it { is_expected.to_not be_valid }
      end
    end
  end
end
