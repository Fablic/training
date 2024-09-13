require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do
  describe '#is_admin?' do
    context 'when user is admin' do
      before do
        @admin_1 = create(:user, id: 1, role: User.roles[:role_admin])
      end

      it 'should return true' do
        res = is_admin?(@admin_1)
        expect(res).to eq true
      end
    end
    context 'when user is normal' do
      before do
        @user_1 = create(:user, id: 1, role: User.roles[:role_normal])
      end

      it 'should return false' do
        res = is_admin?(@user_1)
        expect(res).to eq false
      end
    end
  end
  describe '#is_moderator?' do
    context 'when user is moderator' do
      before do
        @moderator_1 = create(:user, id: 1, role: User.roles[:role_moderator])
      end

      it 'should return true' do
        res = is_moderator?(@moderator_1)
        expect(res).to eq true
      end
    end
    context 'when user is normal' do
      before do
        @user_1 = create(:user, id: 1, role: User.roles[:role_normal])
      end

      it 'should return false' do
        res = is_moderator?(@user_1)
        expect(res).to eq false
      end
    end
  end
  describe '#is_normal?' do
    context 'when user is normal' do
      before do
        @user_1 = create(:user, id: 1, role: User.roles[:role_normal])
      end

      it 'should return true' do
        res = is_normal?(@user_1)
        expect(res).to eq true
      end
    end
    context 'when user is admin' do
      before do
        @admin_1 = create(:user, id: 1, role: User.roles[:role_admin])
      end

      it 'should return false' do
        res = is_normal?(@admin_1)
        expect(res).to eq false
      end
    end
  end
end
