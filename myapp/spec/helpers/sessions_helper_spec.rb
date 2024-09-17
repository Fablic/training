require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  describe '#log_in' do
    context 'when user login' do
      before do
        @user_1 = create(:user, id: 1)
      end

      it 'should get current user data from session' do
        log_in(@user_1)
        cur = current_user
        expect(cur.id).to eq @user_1.id
      end
    end
  end

  describe '#log_out' do
    context 'when user logout' do
      before do
        @user_1 = create(:user, id: 1)
        log_in(@user_1)
      end

      it 'should current user be nil' do
        log_out

        cur = current_user
        expect(cur).to eq nil
      end
    end
  end

  describe '#logged_in?' do
    context 'when user login' do
      before do
        @user_1 = create(:user, id: 1)
        log_in(@user_1)
      end

      it 'should return true' do
        res = logged_in?
        expect(res).to eq true
      end
    end
    context 'when user logout' do
      before do
        @user_1 = create(:user, id: 1)
        log_in(@user_1)
        log_out
      end

      it 'should return false' do
        res = logged_in?
        expect(res).to eq false
      end
    end
  end
end
