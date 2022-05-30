require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  name_max_length = 50
  let(:name) { 'testUser' }
  let(:email) { 'test@gmail.com' }
  let(:password_digest) { 'testpass' }
  let(:admin_flg) { 0 }
  let!(:task) { User.new(name: name, email: email, password_digest: password_digest, admin_flg: admin_flg) }

  describe 'name' do
    context "#{name_max_length}文字以内" do
      let(:name) { 't' * name_max_length }
      it 'バリデーションを通ること' do
        expect(task).to be_valid
      end
    end

    context "#{name_max_length}文字より多い" do
      let(:name) { 't' * (name_max_length + 1) }
      it 'バリデーションで弾かれること' do
        expect(task).not_to be_valid
      end
    end

    context '入力が空の場合' do
      let(:name) { '' }
      it 'バリデーションで弾かれること' do
        expect(task).not_to be_valid
      end
    end
  end

  describe 'email' do
    context 'email以外の形式が入力された時' do
      let(:email) {'abcde12345'}
      it 'バリデーションで弾かれること' do
        expect(task).not_to be_valid
      end
    end

    context '入力が空の場合' do
      let(:email) { '' }
      it 'バリデーションで弾かれること' do
        expect(task).not_to be_valid
      end
    end
  end

  describe 'password' do 
    context '入力が空の場合' do
      let(:password_digest) { '' }
      it 'バリデーションで弾かれること' do
        expect(task).not_to be_valid
      end
    end
  end
end
