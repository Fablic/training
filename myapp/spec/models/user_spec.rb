require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  name_max_length = 50
  let(:name) { 'testUser' }
  let(:email) { 'test@gmail.com' }
  let(:password_digest) { 'testpass' }
  let(:admin_flg) { 0 }
  let!(:user) { User.new(name: name, email: email, password_digest: password_digest, admin_flg: admin_flg) }

  describe 'name' do
    context "#{name_max_length}文字以内" do
      let(:name) { 't' * name_max_length }
      it 'バリデーションを通ること' do
        expect(user).to be_valid
      end
    end

    context "#{name_max_length}文字より多い" do
      let(:name) { 't' * (name_max_length + 1) }
      it 'バリデーションで弾かれること' do
        expect(user).not_to be_valid
      end
    end

    context '入力が空の場合' do
      let(:name) { '' }
      it 'バリデーションで弾かれること' do
        expect(user).not_to be_valid
      end
    end
  end

  describe 'email' do
    context 'email以外の形式が入力された時' do
      let(:email) { 'abcde12345' }
      it 'バリデーションで弾かれること' do
        expect(user).not_to be_valid
      end
    end

    context '入力が空の場合' do
      let(:email) { '' }
      it 'バリデーションで弾かれること' do
        expect(user).not_to be_valid
      end
    end

    context 'すでに登録済みのメールアドレスで登録する場合' do
      let!(:other_user) { FactoryBot.create(:normal_user) }
      let!(:email) { other_user.email }
      it 'バリデーションで弾かれること' do
        expect(user).not_to be_valid
      end
    end
  end

  describe 'password' do
    context '入力が空の場合' do
      let(:password_digest) { '' }
      it 'バリデーションで弾かれること' do
        expect(user).not_to be_valid
      end
    end
  end

  describe 'admin_flg' do
    let!(:admin) { create(:admin_user) }
    let!(:normal) { create(:normal_user)}
    context '更新処理で管理ユーザーが一人も存在しなくなる場合' do
      it 'バリデーションで弾かれること' do
        admin.update(admin_flg: 0)
        expect(admin).not_to be_valid
      end
    end

    context '一般ユーザーの更新' do
      it '正常に行えること' do
        normal.update(admin_flg: 1)
        expect(admin).to be_valid
      end
    end

    context '削除処理で管理ユーザーが一人も存在しなくなる場合' do
      it '削除が行われないこと' do
        admin.destroy
        expect(admin).not_to be_destroyed
      end
    end

    context '一般ユーザーが削除される場合' do
      it '削除が正常に行われること' do
        normal.destroy
        expect(normal).to be_destroyed
      end
    end
  end
end
