# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:name) { 'task' }
  let(:due_at) { Time.current + 10 }
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
      let(:due_at) { Time.current - 10 }
      it { is_expected.to_not be_valid }
    end
  end

  describe 'priority' do
    it '優先事項の値がenumのkeyと違う値の場合登録できない' do
      task = Task.new(
        name: 'task',
        due_at: '2021-08-17 10:59:26',
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
        due_at: '2021-08-17 10:59:26',
        priority: 1,
        progress: 'aaaa',
      )
      expect(task).not_to be_valid
    end
  end
end
