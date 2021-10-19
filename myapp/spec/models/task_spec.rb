require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task) { build(:task) }
  describe '#title' do
    context 'If nil is set' do
      it 'Invalidated and returns an error message' do
        task.title = nil
        expect(task).not_to be_valid
        expect(task.errors.messages).to include(:title)
      end
    end

    context 'If empty is set.' do
      it 'Invalidated and returns an error message' do
        task.title = ''
        expect(task).not_to be_valid
        expect(task.errors.messages).to include(:title)
      end
    end

    context 'If the number of characters is set to be more than the specified number' do
      it 'Invalidated and returns an error message' do
        task.title = 'a' * 21
        expect(task).not_to be_valid
        expect(task.errors.messages).to include(:title)
      end
    end

    context 'If the number of characters is set to less than the specified value' do
      it 'Invalidated and returns an error message' do
        task.title = 'a' * 2
        expect(task).not_to be_valid
        expect(task.errors.messages).to include(:title)
      end
    end
  end

  describe '#detail' do
    context 'If nil is set' do
      it 'Invalidated and returns an error message' do
        task.detail = nil
        expect(task).to be_valid
        expect(task.errors.messages).not_to include(:detail)
      end
    end

    context 'If empty is set.' do
      it 'Invalidated and returns an error message' do
        task.detail = ''
        expect(task).to be_valid
        expect(task.errors.messages).not_to include(:detail)
      end
    end

    context 'If the number of characters is set to be more than the specified number' do
      it 'Invalidated and returns an error message' do
        task.detail = 'a' * 10_001
        expect(task).not_to be_valid
        expect(task.errors.messages).to include(:detail)
      end
    end
  end

  describe '#due_date' do
    context 'If nil is set' do
      it 'Invalidated and returns an error message' do
        task.due_date = nil
        expect(task).not_to be_valid
        expect(task.errors.messages).to include(:due_date)
      end
    end

    context 'If empty is set.' do
      it 'Invalidated and returns an error message' do
        task.due_date = ''
        expect(task).not_to be_valid
        expect(task.errors.messages).to include(:due_date)
      end
    end

    context 'If todays date is set' do
      it 'Enabled, no error message returned' do
        task.due_date = Time.zone.now
        expect(task).to be_valid
        expect(task.errors.messages).not_to include(:due_date)
      end
    end

    context 'If tomorrow date is set' do
      it 'Invalidated and returns an error message' do
        task.due_date = Time.zone.tomorrow
        expect(task).to be_valid
        expect(task.errors.messages).not_to include(:due_date)
      end
    end

    context 'If yesterday date is set' do
      it 'Invalidated and returns an error message' do
        task.due_date = Time.zone.yesterday
        expect(task).not_to be_valid
        expect(task.errors.messages).to include(:due_date)
      end
    end
  end

  describe '#priority' do
    context 'If nil is set' do
      it 'be invalidated' do
        task.priority = nil
        expect(task).not_to be_valid
      end
    end

    context 'If an unintended value is set' do
      it 'Invalidated and returns an error message' do
        task.priority = [*0..100].delete_if { |n| Task.prioritys.values.include?(n) }.sample
        expect(task).not_to be_valid
        expect(task.errors.messages).to include(:priority)
      end
    end
  end

  describe '#status' do
    context 'If nil is set' do
      it 'be invalidated' do
        task.status = nil
        expect(task).not_to be_valid
      end
    end

    context 'If an unintended value is set' do
      it 'Invalidated and returns an error message' do
        task.status = [*0..100].delete_if { |n| Task.statuses.values.include?(n) }.sample
        expect(task).not_to be_valid
        expect(task.errors.messages).to include(:status)
      end
    end
  end
end
