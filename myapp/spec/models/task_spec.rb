# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'Confirm default value' do
    task = Task.new
    expect(task.status).to eq(:open.to_s)
    expect(task.priority).to eq(:low.to_s)
  end

  describe 'Validation' do
    let(:task) {Task.create(title: 'title', due_date: Date.today)}

    it 'All attributes are OK' do
      expect(task.valid?).to eq(true)
    end

    it 'title is empty' do
      task.title = ''
      expect(task.valid?).to eq(false)
    end

    it 'title is nil' do
      task.title = nil
      expect(task.valid?).to eq(false)
    end

    it 'description is empty' do
      task.description = ''
      expect(task.valid?).to eq(true)
    end

    it 'description is nil' do
      task.description = nil
      expect(task.valid?).to eq(true)
    end

    it 'due_date is nil' do
      task.due_date = nil
      expect(task.valid?).to eq(false)
    end

    it 'status is nil' do
      task.status = nil
      expect(task.valid?).to eq(false)
    end

    it 'priority is nil' do
      task.priority = nil
      expect(task.valid?).to eq(false)
    end

  end

  describe 'Search' do
    before do
      @task1 = Task.create!(title: 'test1', description: 'desc1', due_date: '2024-01-01', updated_at: '2024-03-01', status: :open)
      @task2 = Task.create!(title: 'test2', description: 'desc2', due_date: '2024-03-01', updated_at: '2024-02-01', status: :in_progress)
      @task3 = Task.create!(title: 'test3', description: 'desc3', due_date: '2024-02-01', updated_at: '2024-01-01', status: :in_progress)
      @task4 = Task.create!(title: 'test11', description: 'desc3', due_date: '2024-02-01', updated_at: '2024-01-01',status: :in_progress)
    end

    it 'search title, result is not empty' do
      task_list = Task.search('test1', nil)
      ## order by created_at desc
      expect(task_list.count).to eq 2
      expect(task_list[0].title).to include('test1')
      expect(task_list[1].title).to include('test1')
    end

    it 'search title, result is empty' do
      task_list = Task.search('test100', nil)
      expect(task_list.count).to eq 0
    end

    it 'search status, result is not empty' do
      task_list = Task.search(nil, :open)
      ## order by created_at desc
      expect(task_list.count).to eq 1
      expect(task_list[0]).to have_attributes(status: 'open')
    end

    it 'search status, result is empty' do
      task_list = Task.search(nil, :closed)
      expect(task_list.count).to eq 0
    end
  end
end
