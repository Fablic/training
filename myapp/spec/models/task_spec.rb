# frozen_string_literal: true

require 'rails_helper'

describe Task, type: :model do
  describe 'validation' do
    it 'is invalid without name' do
      task = described_class.new(name: nil)
      expect(task).not_to be_valid
    end

    it 'is invalid with too long name' do
      task = described_class.new(name: 'a' * 51)
      expect(task).not_to be_valid
    end

    it 'is valid with name' do
      task = described_class.new(name: 'task')
      expect(task).to be_valid
    end

    it 'is valid with name of 50 letters' do
      task = described_class.new(name: 'a' * 50)
      expect(task).to be_valid
    end
  end

  describe 'search' do
    before do
      FactoryBot.create(:task)
      FactoryBot.create(:task2)
      FactoryBot.create(:task3)
    end

    context 'タスク名で検索したとき' do
      tasks = described_class.ransack({ 'name_cont' => '_3' }).result
      it '該当するタスク名のタスクが表示される' do
        expect(tasks.map(&:name)).to include 'task_name_3'
      end

      it '該当しないタスク名のタスクは表示されない' do
        expect(tasks.map(&:name)).not_to include 'task_name', 'task_name_2'
      end
    end

    context 'ステータスで検索したとき' do
      tasks = described_class.ransack({ 'status_eq' => '1' }).result
      it '該当するステータスのタスクのみが表示される' do
        expect(tasks.map(&:status)).to include '着手中'
      end

      it '該当しないステータスのタスクは表示されない' do
        expect(tasks.map(&:status)).not_to include '未着手', '完了'
      end
    end
  end
end
