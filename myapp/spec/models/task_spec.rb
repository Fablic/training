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
      expect(task.errors[:status]).to eq ["can't be blank", 'is not a number']
    end

    it 'task cannot be created if status is not a number' do
      task = build(:task, status: 'string')
      expect(task).to be_invalid
    end

    it 'show error messages if status is not a number' do
      task = build(:task, status: 'string')
      task.valid?
      expect(task.errors[:status]).to eq ['is not a number']
    end

    it 'task cannot be created without priority' do
      task = build(:task, priority: nil)
      expect(task).to be_invalid
    end

    it 'show error messages if priority is empty' do
      task = build(:task, priority: nil)
      task.valid?
      expect(task.errors[:priority]).to eq ["can't be blank", 'is not a number']
    end

    it 'task cannot be created if priority is not a number' do
      task = build(:task, priority: 'string')
      expect(task).to be_invalid
    end

    it 'show error messages if priority is not a number' do
      task = build(:task, priority: 'string')
      task.valid?
      expect(task.errors[:priority]).to eq ['is not a number']
    end
  end
end
