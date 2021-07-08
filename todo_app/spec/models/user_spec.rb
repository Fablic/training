# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    subject { build(:user, params) }
    let(:params) { { email: email, password: password } }

    context 'valid' do
      let(:email) { Faker::Internet.email }
      let(:password) { Faker::Alphanumeric.alpha(number: 10) }

      it { is_expected.to be_valid }
    end
    context 'when nil email' do
      let(:email) { nil }
      let(:password) { Faker::Alphanumeric.alpha(number: 10) }

      it { is_expected.not_to be_valid }
    end
    context 'when nil password' do
      let(:email) { Faker::Internet.email }
      let(:password) { nil }

      it { is_expected.not_to be_valid }
    end
  end

  describe '#ensure_role_and_admin_user_count' do
    context 'when have 1 admin_user' do
      before { create(:user, role: :admin) }
      it 'is invalid' do
        admin_user = User.admin.first
        admin_user.destroy
        expect(admin_user.errors.messages[:role]).to include('管理者は最低1人必要です')
      end
    end
    context 'when have 2 admin_user' do
      before {
        2.times do
          create(:user, role: :admin)
        end
      }
      it 'can destroy 1 admin_user' do
        admin_users = User.admin
        admin_users.each do |admin_user|
          if User.admin.count > 1
            expect { admin_user.destroy }.to change(User, :count).by(-1)
          else
            expect { admin_user.destroy }.to change(User, :count).by(0)
            expect(admin_user.errors.messages[:role]).to include('管理者は最低1人必要です')
          end
        end
        expect(admin_users.count).to eq(1)
      end
    end
    context 'when have 2 general_user' do
      before {
        2.times do
          create(:user)
        end
      }
      it 'can destroy 2 general_user' do
        general_users = User.general

        general_users.each do |general_user|
          expect { general_user.destroy }.to change(User, :count).by(-1)
        end
        expect(general_users.count).to eq(0)
      end
    end
  end
end
