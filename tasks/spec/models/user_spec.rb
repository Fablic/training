require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ユーザとタスクの紐付け' do
    context 'ユーザを作成し、その後タスクを作成した場合' do
      let(:user) { create(:user_after_create_task) }
      let!(:other_user) { create(:user_after_create_task, email: 'other@test.jp') }
      it 'そのタスクに紐づくユーザを取得できること' do
        expect([user]).to match User.includes(:tasks).where(tasks: { id: user.tasks.ids })
      end
    end
  end

  describe 'ユーザ名バリデーション' do
    let(:user) { build(:user, user_name: user_name) }
    context 'ユーザ名がない場合' do
      let(:user_name) { '' }
      it 'エラーになる' do
        expect(user).to be_invalid
        expect(user.errors[:user_name]).to include('を入力してください')
      end
    end
    context 'ユーザ名の文字数が上限未満の場合' do
      let(:user_name) { 'a' * 49 }
      it '有効である' do
        expect(user).to be_valid
      end
    end
    context 'ユーザ名の文字数が上限と同じの場合' do
      let(:user_name) { 'a' * 50 }
      it '有効である' do
        expect(user).to be_valid
      end
    end
    context 'ユーザ名の文字数が上限を超える場合' do
      let(:user_name) { 'a' * 51 }
      it 'エラーになる' do
        expect(user).to be_invalid
        expect(user.errors[:user_name]).to include('は50文字以内で入力してください')
      end
    end
  end

  describe 'メールアドレスバリデーション' do
    let(:user) { build(:user, email: email) }
    context 'メールアドレスがない場合' do
      let(:email) { '' }
      it 'エラーになる' do
        expect(user).to be_invalid
        expect(user.errors[:email]).to include('を入力してください')
      end
    end
    context 'メールアドレスの文字数が上限未満の場合' do
      let(:email) { "#{'a' * 248}@bb.jp" }
      it '有効である' do
        expect(user).to be_valid
      end
    end
    context 'メールアドレスの文字数が上限と同じ場合' do
      let(:email) { "#{'a' * 249}@bb.jp" }
      it '有効である' do
        expect(user).to be_valid
      end
    end
    context 'メールアドレスが上限を超える場合' do
      let(:email) { "#{'a' * 250}@bb.jp" }
      it 'エラーになる' do
        expect(user).to be_invalid
        expect(user.errors[:email]).to include('は255文字以内で入力してください')
      end
    end
    context 'メールアドレスのフォーマットでない場合' do
      let(:email) { 'usertest.jp' }
      it 'エラーになる' do
        expect(user).to be_invalid
        expect(user.errors[:email]).to include('は不正な値です')
      end
    end
    context 'メールアドレスが重複していた場合' do
      let!(:other_user) { create(:user) }
      let(:email) { other_user.email }
      it 'エラーになる' do
        expect(user).to be_invalid
        expect(user.errors[:email]).to include('はすでに存在します')
      end
    end
    context 'メールアドレスが大文字の場合' do
      let(:email) { 'USER@test.jp' }
      it '小文字化されていること' do
        user.save
        expect(user[:email]).to eq('user@test.jp')
      end
    end
  end

  describe 'パスワードバリデーション' do
    let(:user) { build(:user, password: password, password_confirmation: password) }
    context 'パスワードがない場合' do
      let(:password) { nil }
      it 'エラーになる' do
        expect(user).to be_invalid
        expect(user.errors[:password]).to include('を入力してください')
      end
    end
    context 'パスワードの文字数が下限未満の場合' do
      let(:password) { "#{'a' * 6}1" }
      it 'エラーになる' do
        expect(user).to be_invalid
        expect(user.errors[:password]).to include('は8文字以上で入力してください')
      end
    end
    context 'パスワードの文字数が下限と同じ場合' do
      let(:password) { "#{'a' * 7}1" }
      it '有効である' do
        expect(user).to be_valid
      end
    end
    context 'パスワードの文字数が下限を超える場合' do
      let(:password) { "#{'a' * 8}1" }
      it '有効である' do
        expect(user).to be_valid
      end
    end
    context 'パスワードの文字数が上限未満の場合' do
      let(:password) { "#{'a' * 70}1" }
      it '有効である' do
        expect(user).to be_valid
      end
    end
    context 'パスワードの文字数が上限と同じ場合' do
      let(:password) { "#{'a' * 71}1" }
      it '有効である' do
        expect(user).to be_valid
      end
    end
    context 'パスワードの文字数が上限を超える場合' do
      let(:password) { "#{'a' * 72}1" }
      it 'エラーになる' do
        expect(user).to be_invalid
        expect(user.errors[:password]).to include('は72文字以内で入力してください')
      end
    end
    context 'パスワードがフォーマットでない場合' do
      let(:password) { 'a' * 70 }
      it 'エラーになる' do
        expect(user).to be_invalid
        expect(user.errors[:password]).to include('は不正な値です')
      end
    end
    context 'パスワードが確認と一致していない場合' do
      let(:not_match_password_user) { build(:user, password_confirmation: '') }
      it 'エラーになる' do
        expect(not_match_password_user).to be_invalid
        expect(not_match_password_user.errors[:password_confirmation]).to include('とパスワードの入力が一致しません')
      end
    end
  end

  describe '削除日時のバリデーション（update処理時のみ）' do
    let(:user) { create(:user) }
    context 'NULLの場合' do
      let(:deleted_at) { nil }
      it '有効である' do
        expect(user.update!(deleted_at: deleted_at)).to eq true
      end
    end
    context '正常な値の場合' do
      let(:deleted_at) { Time.current.strftime('%Y-%m-%d %H:%M:%S') }
      it '有効である' do
        expect(user.update!(deleted_at: deleted_at)).to eq true
      end
    end
    context '不正な値の場合' do
      let(:deleted_at) { 'aaa' }
      it 'エラーになる' do
        expect { user.update!(deleted_at: deleted_at) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe 'scope' do
    context '論理削除されたユーザが存在する場合' do
      let!(:user_list) { create_list(:user, 5).push(deleted_user) }
      let(:deleted_user) { create(:user, deleted_at: Time.current.strftime('%Y-%m-%d %H:%M:%S')) }
      let(:user_list_deleted_at_null) { user_list.select { |user| user.deleted_at.nil? } }
      it '論理削除されていないユーザを全て取得すること' do
        expect(User.without_deleted).to match_array user_list_deleted_at_null
      end
    end
    context 'ユーザ情報を取得する場合' do
      let(:user) { create(:user) }
      let(:count_tasks) { 5 }
      let!(:task_list) { create_list(:task_list_item, count_tasks) }
      let!(:task_link) do
        [
          create(:task_link, task_id: task_list[0].id, user_id: user.id),
          create(:task_link, task_id: task_list[1].id, user_id: user.id),
          create(:task_link, task_id: task_list[2].id, user_id: user.id),
          create(:task_link, task_id: task_list[3].id, user_id: user.id),
          create(:task_link, task_id: task_list[4].id, user_id: user.id)
        ]
      end
      it 'そのユーザのタスク数を取得すること' do
        expect(User.tasks_count[0].tasks_count).to match count_tasks
      end
    end
  end
end
