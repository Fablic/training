require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'バリデーションのテスト' do
    context 'タスク名、概要、終了期限が入力' do
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

    context '終了期限が未入力' do
      it 'タスクを登録できず、終了期限を入力してくださいと表示' do
        task = build(:task, deadline: '')

        expect(task).to be_invalid
        expect(task.errors.full_messages).to include('終了期限を入力してください')
      end
    end
  end

  describe 'ソート' do
    let!(:task1) { create(:task, id: '1', title: 'task1', deadline: '2023/04/29', created_at: '2023/04/27 09:00') }
    let!(:task2) { create(:task, id: '2', title: 'task2', deadline: '2023/04/28', created_at: '2023/04/27 08:00') }
    let!(:task3) { create(:task, id: '3', title: 'task3', deadline: '2023/04/27', created_at: '2023/04/27 07:00') }

    context '終了期限ソートが昇順のとき' do
      it '終了期限の新しい日付順に表示' do
        expect(Task.deadline_order('asc')).to eq [task3, task2, task1]
      end
    end

    context '終了期限ソートが降順のとき' do
      it '終了期限の古い日付順に表示' do
        expect(Task.deadline_order('desc')).to eq [task1, task2, task3]
      end
    end
  end

end
