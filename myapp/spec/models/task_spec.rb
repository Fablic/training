require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task) { build(:task) }

  describe '#name' do
    it 'with nil is not valid' do
      task.name = nil
      expect(task).not_to be_valid
      expect(task.errors.messages).to include(:name)
    end

    it 'with blank string is not valid' do
      task.name = ''
      expect(task).not_to be_valid
      expect(task.errors.messages).to include(:name)
    end
  end

  describe '#description' do
    it 'with nil is not valid' do
      task.description = nil
      expect(task).not_to be_valid
      expect(task.errors.messages).to include(:description)
    end

    it 'with blank string is not valid' do
      task.description = ''
      expect(task).not_to be_valid
      expect(task.errors.messages).to include(:description)
    end
  end

  describe '#due_date' do
    it 'can be nil' do
      task.due_date = nil
      expect(task).to be_valid
    end

    it 'can be nil as well as Time' do
      task.due_date = Time.current
      expect(task).to be_valid
    end
  end

  describe '#priority' do
    it 'can have defined value as enum' do
      expect(task.high!).to be true
      expect(task.normal!).to be true
      expect(task.low!).to be true
    end
  end

  describe '#status' do
    it 'can have defined value as enum' do
      expect(task.waiting!).to be true
      expect(task.doing!).to be true
      expect(task.done!).to be true
    end
  end
end
