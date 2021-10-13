require 'rails_helper'

RSpec.describe Task, type: :model do

  describe '#title' do
    it 'with nil is not valid' do
      task = build(:task, title: nil)
      expect(task).not_to be_valid
      expect(task.errors.messages).to include(:title)
    end

    it 'Exceeds the specified number of characters' do
      task = build(:task, title: "a" * 21)
      expect(task).not_to be_valid
      expect(task.errors.messages).to include(:title)
    end

    it 'Less than the specified number of characters' do
      task = build(:task, title: "a" * 2)
      expect(task).not_to be_valid
      expect(task.errors.messages).to include(:title)
    end
  end

  describe '#detail' do
    it 'with nil is valid' do
      task = build(:task, detail: nil)
      expect(task).to be_valid
    end

    it 'Exceeds the specified number of characters' do
      task = build(:task, detail: "a" * 10001)
      expect(task).not_to be_valid
      expect(task.errors.messages).to include(:detail)
    end
  end

  describe '#due_date' do
    it 'with nil is valid' do
      task = build(:task, due_date: nil)
      expect(task).not_to be_valid
      expect(task.errors.messages).to include(:due_date)
    end

    it 'Check the date' do
      expect(build(:task, due_date: Time.zone.now)).to be_valid
      expect(build(:task, due_date: Time.zone.tomorrow)).to be_valid
      expect(build(:task, due_date: Time.zone.yesterday)).not_to be_valid
    end
  end

  describe '#priority' do
    it 'with nil is valid' do
      task = build(:task, priority: nil)
      expect(task).not_to be_valid
    end

    it 'If an out-of-specification value is received' do
      task = build(:task, priority: [*0..100].delete_if { |n| Task.prioritys.values.include?(n) }.sample) 
      expect(task).not_to be_valid
      expect(task.errors.messages).to include(:priority)
    end
  end

  describe '#status' do
    it 'with nil is valid' do
      task = build(:task, status: nil)
      expect(task).not_to be_valid
    end

    it 'If an out-of-specification value is received' do
      task = build(:task, status: [*0..100].delete_if { |n| Task.statuses.values.include?(n) }.sample) 
      expect(task).not_to be_valid
      expect(task.errors.messages).to include(:status)
    end
  end
end
