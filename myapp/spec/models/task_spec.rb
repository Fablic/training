require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'バリデーションのテスト' do
    context 'タスク名、概要、終了期限、ステータスを入力' do
      it 'タスクを登録できる' do
        task = build(:task)

        expect(task).to be_valid
      end
    end

    context '概要が未入力' do
      it 'タスクを登録できる' do
        task = build(:task, content: '')

        expect(task).to be_valid
      end
    end

    context 'タスク名が30文字で入力' do
      it 'タスクを登録できる' do
        task = build(:task, title: 'a' * 30)

        expect(task).to be_valid
      end
    end

    context 'タスク名が未入力' do
      it 'タスクを登録できず、タスク名を入力してくださいと表示' do
        task = build(:task, title: '')

        expect(task).to be_invalid
        expect(task.errors.full_messages).to include('タスク名を入力してください')
      end
    end

    context 'タスク名が31文字以上の入力' do
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

    context '終了期限が未入力' do
      it 'タスクを登録できず、終了期限を入力してくださいと表示' do
        task = build(:task, deadline: '')

        expect(task).to be_invalid
        expect(task.errors.full_messages).to include('終了期限を入力してください')
      end
    end
  end
end
