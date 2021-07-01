require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.new(name: name, email: email, password: password) }
  let(:name) { 'ユーザー名' }
  let(:email) { 'test@example.com' }
  let(:password) { 'testtest1234' }

  context 'すべての項目が入力されている場合' do
    it ('有効であること') { expect(user).to be_valid }
    it ('パスワードとは異なる値でpassword_digestが保存されていること') { expect(user.password_digest).not_to eq(user.password) }
  end

  context 'ユーザー名が50文字の場合' do
    let(:name) { 'あ' * 50 }

    it ('有効であること') { expect(user).to be_valid }
  end

  context 'ユーザー名が51文字の場合' do
    let(:name) { 'あ' * 51 }

    it '無効となること' do
      user.valid?
      expect(user.errors.errors[0].full_message).to include('ユーザー名は50文字以内で入力してください')
    end
  end

  context 'ユーザー名がない場合' do
    let(:name) { '' }

    it '無効となること' do
      user.valid?
      expect(user.errors.errors[0].full_message).to include('ユーザー名を入力してください')
    end
  end

  context 'Emailが255文字の場合' do
    let(:email) { "#{'a' * 243}@example.com" }

    it ('有効であること') { expect(user).to be_valid }
  end

  context 'Emailが256文字の場合' do
    let(:email) { "#{'a' * 244}@example.com" }

    it '無効となること' do
      user.valid?
      expect(user.errors.errors[0].full_message).to include('Emailは255文字以内で入力してください')
    end
  end

  context 'Emailが規定のフォーマットと異なる場合' do
    let(:email) { "#{'a' * 244}example.com" }

    it '無効となること' do
      user.valid?
      expect(user.errors.errors[0].full_message).to include('Emailは不正な値です')
    end
  end

  context 'Emailがない場合' do
    let(:email) { '' }

    it '無効となること' do
      user.valid?
      expect(user.errors.errors[0].full_message).to include('Emailを入力してください')
    end
  end

  context '同じEmailがすでに登録されている場合' do
    before { create(:user) }

    it '無効となること' do
      user.valid?
      expect(user.errors.errors[0].full_message).to include('Emailはすでに存在します')
    end
  end

  context 'パスワードが10文字の場合' do
    let(:password) { 'a' * 10 }

    it ('有効であること') { expect(user).to be_valid }
  end

  context 'パスワードが9文字の場合' do
    let(:password) { 'a' * 9 }

    it '無効となること' do
      user.valid?
      expect(user.errors.errors[0].full_message).to include('パスワードは10文字以上で入力してください')
    end
  end
end
