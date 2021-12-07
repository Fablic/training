# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  let(:name) { 'TaroRakuten' }
  let(:password) { 'rakutenpass' }
  let(:privilege) { :user }

  describe 'バリデーション' do
    subject { User.new(name: name, password: password, privilege: privilege) }

    context '全項目入力' do
      it { is_expected.to be_valid }
    end

    context 'nameカラム' do
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
        before do
          create(:user, name: 'HanakoRakuten', password: 'hanakopass', privilege: :user, deleted: 0)
        end

        let(:name) { 'HanakoRakuten' }

        it { is_expected.not_to be_valid }
      end

      context 'deletedのユーザー名と重複' do
        before do
          create(:user, name: 'YoshioRakuten', password: 'yoshiopass', privilege: :user, deleted: 1)
        end

        let(:name) { 'YoshioRakuten' }

        it { is_expected.to be_valid }
      end
    end

    context 'passwordカラム' do
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

    context 'privilegeカラム' do
      context '許容される値(user)' do
        let(:privilege) { :user }

        it { is_expected.to be_valid }
      end

      context '許容される値(admin)' do
        let(:privilege) { :admin }

        it { is_expected.to be_valid }
      end

      context '許容されない値' do
        let(:privilege) { :anonymous }

        it { is_expected.not_to be_valid }
      end
    end
  end

  context 'delete_user_and_tasks' do
    context '例外が発生しない場合' do
      let(:user_delete) { create(:user, deleted: 0) }
      let!(:task_delete) { create(:task, name: 'task_delete', user_id: user_delete.id, deleted: 0) }

      it '正常にDB更新されること' do
        # 実行
        expect(User.delete_user_and_tasks(user_delete.id)).to eq true
        expect(User.find_by(id: user_delete.id).deleted).to eq 1
        expect(Task.find_by(id: task_delete.id).deleted).to eq 1
      end
    end

    context 'DB更新で例外が発生した場合' do
      let(:user_not_delete) { create(:user, deleted: 0) }
      let!(:task_not_delete) { create(:task, name: 'task_not_delete', user_id: user_not_delete.id, deleted: 0) }

      it 'ロールバックが実行されること' do
        # 例外を発生させる
        allow(User).to receive(:delete_user).and_raise StandardError

        # 実行
        expect(User.delete_user_and_tasks(user_not_delete.id)).to eq false
        expect(User.find_by(id: user_not_delete.id).deleted).to eq 0
        expect(Task.find_by(id: task_not_delete.id).deleted).to eq 0
      end
    end
  end
end
