require 'rails_helper'

describe User, type: :model do
  describe '#validation' do
    describe 'email' do
      context 'email設定' do
        subject(:user) { FactoryBot.build(:user, email: 'test@example.com') }

        it { is_expected.to be_valid }
      end

      context 'email未設定' do
        subject(:user) { FactoryBot.build(:user, email: '') }

        it { is_expected.to be_invalid }
      end

      context 'email重複登録' do
        let!(:user) { FactoryBot.create(:user, email: 'test@example.com') }

        it { expect { FactoryBot.create(:user, email: 'test@example.com') }.to raise_error(ActiveRecord::RecordInvalid) }
      end
    end
  end

  describe '#authenticate' do
    context 'パスワード一致' do
      let!(:user) { FactoryBot.create(:user, password_digest: 'password') }
      subject(:hash) { user.authenticate('password') }

      it { is_expected.to be(true) }
    end

    context 'パスワード不一致' do
      let!(:user) { FactoryBot.create(:user, password_digest: 'password') }
      subject(:hash) { user.authenticate('password_disagreement') }

      it { is_expected.to be(false) }
    end
  end

  describe '#create_salt' do
    let(:salt) { User.create_salt }

    it '文字列の長さが64桁か' do
      expect(salt.length).to be(64)
    end
  end

  describe '#hash' do
    subject(:hash) { User.hash('password', '11137ccd382f0e223a5588d13219847cc2708c8c330918887a2e1fa48b1c737d') }

    it { is_expected.to eq('9eb43658f87aaa44b08e329811a5eeb06559644291f9cb8d95e5789b866fb1c011137ccd382f0e223a5588d13219847cc2708c8c330918887a2e1fa48b1c737d') }
  end

  describe '#create_login_token' do
    subject(:login_token_length) { User.create_login_token.length }

    it { is_expected.to be(22) }
  end

  describe '#encrypt_login_token' do
    subject(:token) { User.encrypt_login_token('Eal3h7Z-OcKjw--jcej1BA') }

    it { is_expected.to eq('55eb05451aa68201ac09f4384833dfcb7241acb270ea495dc3aaad538ed15738') }
  end
end
