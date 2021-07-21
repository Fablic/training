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
end
