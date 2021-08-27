# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    let(:name) { 'task' }
    let(:due_at) { Time.current + 10.days }
    let(:priority) { 1 }
    let(:progress) { 1 }
    subject { build(:task, name: name, due_at: due_at, priority: priority, progress: progress) }

    context '登録可能な形式' do
      it { is_expected.to be_valid }
    end

    describe 'name' do
      context 'nameが空の場合に登録できない' do
        let(:name) { nil }
        it { is_expected.to_not be_valid }
      end

      context 'nameが30文字を超えた場合' do
        let(:name) { 'a' * 31 }
        it { is_expected.to_not be_valid }
      end
    end

    describe 'due_at' do
      context 'in_time_zoneで変換できない形式の場合登録できない' do
        let(:due_at) { '2021-08aa 10:59:26' }
        it { is_expected.to_not be_valid }
      end

      context '現在時刻より以前の場合登録できない' do
        let(:due_at) { Time.current - 10.days }
        it { is_expected.to_not be_valid }
      end
    end

    describe 'priority' do
      it '優先事項の値がenumのkeyと違う値の場合登録できない' do
        task = Task.new(
          name: 'task',
          due_at: Time.current + 10.days,
          priority: 'aa',
          progress: 1,
        )
        expect(task).not_to be_valid
      end
    end

    describe 'progress' do
      it '進捗状況の値がenumのkeyと違う値の場合登録できない' do
        task = Task.new(
          name: 'task',
          due_at: Time.current + 10.days,
          priority: 1,
          progress: 'aaaa',
        )
        expect(task).not_to be_valid
      end
    end
  end

  describe 'scope' do
    subject { tasks(task1, task2)}

    describe 'search_name' do
      context '何も入れずに検索' do
        let(:task1) { create :task, name: 'task_1' }
        let(:task2) { create :task, name: 'task_2' }
        it { expect(Task.search_name('')).to include(task1, task2) }
      end

      context 'nameのパラメーターをいれて検索する' do
        let(:task1) { create :task, name: 'task_1' }
        let(:task2) { create :task, name: 'task_2' }
        it { expect(Task.search_name('1')).to include(task1) }
      end
    end

    describe 'search_progress' do
      context '何も入れずに検索' do
        let(:task1) { create :task, progress: 1 }
        let(:task2) { create :task, progress: 2 }
        it { expect(Task.search_progress('')).to include(task1, task2) }
      end

      context 'Doneをいれて検索' do
        let(:task1) { create :task, progress: 1 }
        let(:task2) { create :task, progress: 2 }
        it { expect(Task.search_progress('Done')).to include(task2) }
      end
    end

    describe 'sort' do
      context '何も入れずに検索し、created_atの降順になるか確認' do
        let(:task1) { create :task, created_at: '2019-09-02 10:59:26' }
        let(:task2) { create :task, created_at: '2018-09-02 10:59:26' }
        it { expect(Task.sort_column_direction('', '')).to eq [task1, task2] }
      end

      context 'ascを入れて検索し、created_atの昇順になるか確認' do
        let(:task1) { create :task, created_at: '2019-09-02 10:59:26' }
        let(:task2) { create :task, created_at: '2018-09-02 10:59:26' }
        it { expect(Task.sort_column_direction('', 'asc')).to eq [task2, task1] }
      end

      context 'nameを入れて検索し、nameの降順になるか確認' do
        let(:task1) { create :task, name: 'task_1' }
        let(:task2) { create :task, name: 'task_2' }
        it { expect(Task.sort_column_direction('name', '')).to eq [task2, task1] }
      end

      context 'nameとascを入れて検索し、nameの昇順になるか確認' do
        let(:task1) { create :task, name: 'task_1' }
        let(:task2) { create :task, name: 'task_2' }
        it { expect(Task.sort_column_direction('name', 'asc')).to eq [task1, task2] }
      end
    end
  end
end
