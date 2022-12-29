# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User model->', type: :model do
  describe 'last_admin? method:' do
    let!(:admin_user) { FactoryBot.create(:user) }
    let!(:normal_user) { FactoryBot.create(:user, email: 'user@normal.com', role: 0) }

    subject { target_user.last_admin? }

    context 'for the admin user' do
      let(:target_user) { admin_user }

      context 'if the user is the last admin' do
        it 'return true' do
          is_expected.to eq true
        end
      end

      context 'if the user is not the last one' do
        let!(:admin_user2) { FactoryBot.create(:user, email: 'user2@admin.com') }
        it 'return false' do
          is_expected.to eq false
        end
      end
    end

    context 'for the normal user' do
      let(:target_user) { normal_user }
      it 'return true' do
        is_expected.to eq false
      end
    end
  end
end
