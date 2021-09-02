# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  describe 'method' do
    describe 'log_in' do
      let(:user) { build(:user) }
      subject { log_in(user) }

      context 'user情報を入れる' do
        it { expect(session[:user_id] == user.id) }
      end
    end

    describe 'log_out' do
      let!(:rspec_session) { { user_id: 1 } }
      subject { log_out }

      context '正常な動作' do
        it { expect(session[:user_id].nil?) }
      end
    end

    describe 'current_user' do
      let(:user) { build(:user) }
      let!(:rspec_session) { { user_id: user.id } }
      subject { current_user }

      context 'ログイン時' do
        it { expect(current_user == user) }
      end

      context '非ログイン時' do
        before { session.delete(:user_id) }
        it { expect(current_user.nil?) }
      end
    end

    describe 'logged_in?' do
      let(:user) { create(:user) }
      let!(:rspec_session) { { user_id: user.id } }
      subject { logged_in? }

      context 'ログイン時' do
        it { is_expected.to eq true }
      end

      context '非ログイン時' do
        before { session.delete(:user_id) }
        it { is_expected.to eq false }
      end
    end

    describe 'permission?' do
      let(:user) { create(:user) }
      let!(:rspec_session) { { user_id: user.id } }
      let!(:access_place_id) { user.id }
      subject { permission?(access_place_id) }

      context 'セッションのユーザーidと編集や削除削除項目のidが一致する' do
        it { is_expected.to eq true }
      end

      context 'セッションのユーザーidと編集や削除削除項目のidが一致しない' do
        let!(:access_place_id) { user.id + 1 }
        it { is_expected.to eq false }
      end
    end
  end
end
