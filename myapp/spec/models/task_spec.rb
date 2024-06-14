# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'is valid with a title up to 50 characters' do
    task = Task.new(title: 'a' * 50, description: 'Valid Description', deadline: 2.days.from_now)
    expect(task).to be_valid
  end

  it 'is not valid with a title over 50 characters' do
    task = Task.new(title: 'a' * 51, description: 'Valid Description', deadline: 2.days.from_now)
    expect(task).not_to be_valid
  end

  it 'is valid with a long description up to 500 characters' do
    task = Task.new(title: 'Valid Title', description: 'a' * 500, deadline: 2.days.from_now)
    expect(task).to be_valid
  end

  it 'is not valid with a description over 500 characters' do
    task = Task.new(title: 'Valid Title', description: 'a' * 501, deadline: 2.days.from_now)
    expect(task).not_to be_valid
  end

  it 'is not valid without a title' do
    task = Task.new(title: nil, description: 'Valid Description', deadline: 2.days.from_now)
    expect(task).not_to be_valid
  end

  it 'is not valid with an empty title' do
    task = Task.new(title: '', description: 'Valid Description', deadline: 2.days.from_now)
    expect(task).not_to be_valid
  end

  it 'is valid without a description' do
    task = Task.new(title: 'Valid Title', description: nil, deadline: 2.days.from_now)
    expect(task).to be_valid
  end

  it 'is valid with an empty description' do
    task = Task.new(title: 'Valid Title', description: '', deadline: 2.days.from_now)
    expect(task).to be_valid
  end

  it 'is valid without a deadline' do
    task = Task.new(title: 'Valid Title', description: 'Valid Description', deadline: nil)
    expect(task).to be_valid
  end

  it 'is not valid with a deadline in the past' do
    task = Task.new(title: 'Valid Title', description: 'Valid Description', deadline: Date.yesterday)
    expect(task).not_to be_valid
    expect(task.errors[:deadline]).to include('は過去の日付に設定できません。')
  end

  it 'is valid with valid attributes' do
    task = Task.new(title: 'Task 1', description: 'Description 1', deadline: 2.days.from_now)
    expect(task).to be_valid
  end

  it 'is not valid with a deadline out of the acceptable range' do
    task = Task.new(title: 'Valid Title', description: 'Valid Description', deadline: '222222-01-30')
    expect(task).not_to be_valid
    expect(task.errors[:deadline]).to include('日付が範囲外です。')
  end

  it 'is valid with a deadline within the acceptable range' do
    task = Task.new(title: 'Valid Title', description: 'Valid Description', deadline: Date.today + 5.years)
    expect(task).to be_valid
  end

  it 'is valid with a deadline at the start of the acceptable range' do
    task = Task.new(title: 'Valid Title', description: 'Valid Description', deadline: Date.today)
    expect(task).to be_valid
  end

  it 'is valid with a deadline at the end of the acceptable range' do
    task = Task.new(title: 'Valid Title', description: 'Valid Description', deadline: Date.today + 10.years)
    expect(task).to be_valid
  end

  it 'is not valid with a deadline after the end of the acceptable range' do
    task = Task.new(title: 'Valid Title', description: 'Valid Description', deadline: Date.today + 11.years)
    expect(task).not_to be_valid
    expect(task.errors[:deadline]).to include('日付が範囲外です。')
  end

  describe 'scopes' do
    before do
      @task1 = Task.create!(title: 'Task 1', status: '未着手', created_at: 1.day.ago)
      @task2 = Task.create!(title: 'Task 2', status: '着手中', created_at: 2.days.ago)
      @task3 = Task.create!(title: 'Task 3', status: '完了', created_at: 3.days.ago)
    end

    it 'returns tasks with the specified status' do
      expect(Task.未着手).to include(@task1)
      expect(Task.未着手).not_to include(@task2, @task3)
    end

    it 'returns tasks with the specified title' do
      expect(Task.where(title: 'Task 1')).to include(@task1)
      expect(Task.where(title: 'Task 1')).not_to include(@task2, @task3)
    end
  end
end
