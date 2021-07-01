require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'バリデーション' do
    let(:notStartedTaskStatus) { create(:notStarted) }
    let(:lowTaskPriority) { create(:low) }
    context 'タスク名、ステータス、優先度がある場合' do
      it '有効である' do
        task = Task.new(
          task_name: 'テストタスク名',
          status: notStartedTaskStatus,
          priority: lowTaskPriority
        )
        expect(task).to be_valid
      end
    end
    context 'タスク名がない場合' do
      xit 'エラーになる' do
        task = Task.new(
          task_name: nil,
          status: notStartedTaskStatus,
          priority: lowTaskPriority
        )
        task.valid?
        expect(task.errors[:task_name]).to include('must exist')
      end
    end
    context 'ステータスがない場合' do
      xit 'エラーになる' do
        task = Task.new(
          task_name: 'テストタスク',
          status: nil,
          priority: lowTaskPriority
        )
        task.valid?
        expect(task.errors[:status]).to include('must exist')
      end
    end
    context '優先度がない場合' do
      xit 'エラーになる' do
        task = Task.new(
          task_name: 'テストタスク',
          status: notStartedTaskStatus,
          priority: nil
        )
        task.valid?
        expect(task.errors[:priority]).to include('must exist')
      end
    end
  end
  describe 'scope' do
    context 'created_at_desc' do
      let(:task_list) do
        [
          create(:task_list_item),
          create(:task_list_item, created_at: Time.current + 1.day),
          create(:task_list_item, created_at: Time.current + 2.days)
        ]
      end
      it '作成日時の降順で取得できる' do
        expect(Task.created_at_desc).to match [task_list[2], task_list[1], task_list[0]]
      end
    end
  end
end
