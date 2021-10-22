# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  before(:all) do
    create(:user, name: 'HanakoRakuten', password: 'hanakopass', privilege: 'user', deleted: 0)
    create(:user, name: 'YoshioRakuten', password: 'yoshiopass', privilege: 'user', deleted: 1)
  end

  let(:user) { User.new(name: name, password: password, privilege: privilege) }
  let(:name) { 'TaroRakuten' }
  let(:password) { 'rakutenpass' }
  let(:privilege) { 'user' }

  describe '正常系' do
    subject { user }

    context '全項目入力' do
      it { is_expected.to be_valid }
    end
  end

  describe 'バリデーションのテスト' do
    describe 'nameカラム' do
      subject { user }

      context '空欄' do
        let(:name) { '' }

        it { is_expected.not_to be_valid }
      end

      context '20文字以内' do
        let(:name) { 'a' * 20 }

        it { is_expected.to be_valid }
      end

      context '21文字以上' do
        let(:name) { 'a' * 21 }

        it { is_expected.not_to be_valid }
      end

      context 'ユーザー名重複' do
        let(:name) { 'HanakoRakuten' }

        it { is_expected.not_to be_valid }
      end

      context 'deletedのユーザー名と重複' do
        let(:name) { 'YoshioRakuten' }

        it { is_expected.to be_valid }
      end
    end

    describe 'passwordカラム' do
      subject { user }

      context '空欄' do
        let(:password) { '' }

        it { is_expected.not_to be_valid }
      end

      context '20文字以内' do
        let(:password) { 'a' * 20 }

        it { is_expected.to be_valid }
      end

      context '21文字以上' do
        let(:password) { 'a' * 21 }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'privilegeカラム' do
      subject { user }

      context '許容される値(user)' do
        let(:privilege) { 'user' }

        it { is_expected.to be_valid }
      end

      context '許容される値(admin)' do
        let(:privilege) { 'admin' }

        it { is_expected.to be_valid }
      end

      context '許容されない値' do
        let(:privilege) { 'anonymous' }

        it { is_expected.not_to be_valid }
      end
    end
  end
end
