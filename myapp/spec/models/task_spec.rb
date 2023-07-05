# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task do
  describe 'validaton' do
    it 'create task successfully' do
      task = build(:task)
      expect(task).to be_valid
    end

    it 'no error messages when task created successfully' do
      task = build(:task)
      task.valid?
      expect(task.errors).to be_empty
    end

    it 'task cannot be created without name' do
      task = build(:task, name: '')
      expect(task).to be_invalid
    end

    it 'show error messages if name is empty' do
      task = build(:task, name: '')
      task.valid?
      expect(task.errors[:name]).to eq ["can't be blank"]
    end

    it 'task cannot be created with name longer than 255 characters' do
      task = build(:task, name: 'a' * 256)
      expect(task).to be_invalid
    end

    it 'show error messages if name is longer than 255 characters' do
      task = build(:task, name: 'a' * 256)
      task.valid?
      expect(task.errors[:name]).to eq ['is too long (maximum is 255 characters)']
    end

    it 'task cannot be created with description longer than 1000 characters' do
      task = build(:task, description: 'a' * 1001)
      expect(task).to be_invalid
    end

    it 'show error messages if description is longer than 1000 characters' do
      task = build(:task, description: 'a' * 1001)
      task.valid?
      expect(task.errors[:description]).to eq ['is too long (maximum is 1000 characters)']
    end

    it 'task cannot be created without status' do
      task = build(:task, status: nil)
      expect(task).to be_invalid
    end

    it 'show error messages if status is empty' do
      task = build(:task, status: nil)
      task.valid?
      expect(task.errors[:status]).to eq ["can't be blank", 'is not included in the list']
    end

    it 'task cannot be created if status is not included in the enum list' do
      expect { build(:task, status: 'string') }
        .to raise_error(ArgumentError)
              .with_message(/is not a valid status/)
    end

    it 'task cannot be created without priority' do
      task = build(:task, priority: nil)
      expect(task).to be_invalid
    end

    it 'show error messages if priority is empty' do
      task = build(:task, priority: nil)
      task.valid?
      expect(task.errors[:priority]).to eq ["can't be blank", 'is not included in the list']
    end

    it 'task cannot be created if priority is not included in the enum list' do
      expect { build(:task, priority: 'string') }
        .to raise_error(ArgumentError)
              .with_message(/is not a valid priority/)
    end
  end

  describe 'check_scope' do
    let!(:task_first) { create(:task, name: 'Task1', priority: Task.priorities[:High], status: Task.statuses[:Doing], expired_date: '2023-06-30') }
    let!(:task_second) { create(:task, name: 'Task2', priority: Task.priorities[:Low], status: Task.statuses[:Done], expired_date: '2024-06-30') }
    let!(:task_third) { create(:task, name: 'Task3', priority: Task.priorities[:Medium], status: Task.statuses[:Todo], expired_date: '2023-07-30') }

    it 'search by name successfully', :aggregate_failures do
      tasks = Task.search_by_name('2')
      expect(tasks).to include task_second
      expect(tasks).not_to include task_first
      expect(tasks).not_to include task_third
    end

    it 'search by status successfully', :aggregate_failures do
      tasks = Task.search_by_status(Task.statuses[:Doing])
      expect(tasks).to include task_first
      expect(tasks).not_to include task_second
      expect(tasks).not_to include task_third
    end

    it 'get correct order by sorting' do
      tasks = Task.sort_by_column('expired_date', 'DESC')
      expect(tasks).to contain_exactly(task_second, task_third, task_first)
    end
  end
end
