require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'バリデーションのテスト' do
    context 'タスク名、概要、終了期限が入力されている時' do
      it 'タスクを登録できる' do
        task = build(:task)

        expect(task).to be_valid
      end
    end

    context 'タスク名のみ入力されている時' do
      it 'タスクを登録できる' do
        task = build(:task, content: '')

        expect(task).to be_valid
      end
    end

    context 'タスク名が29文字入力されている時' do
      it 'タスクを登録できる' do
        task = build(:task, title: 'a' * 30)

        expect(task).to be_valid
      end
    end

    context 'タスク名が空欄の時' do
      it 'タスクを登録できず、タスク名を入力してくださいと表示' do
        task = build(:task, title: '')

        expect(task).to be_invalid
        expect(task.errors.full_messages).to include('タスク名を入力してください')
      end
    end

    context 'タスク名が30文字以上の時' do
      it 'タスクを登録できず、タスク名は30文字以内で入力してくださいと表示' do
        task = build(:task, title: 'a' * 31)

        expect(task).to be_invalid
        expect(task.errors.full_messages).to include('タスク名は30文字以内で入力してください')
      end
    end

    context '終了期限を選択していない時' do
      it 'タスクを登録できず、ステータスは一覧にありませんと表示' do
        task = build(:task, status: '------')

        expect(task).to be_invalid
        expect(task.errors.full_messages).to include('ステータスは一覧にありません')
      end
    end
  end
end
