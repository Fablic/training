# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'Confirm default value' do
    user = User.create(name: 'test', password: 'test')
    task = Task.create(user_id: user.id)
    expect(task.status).to eq(:open.to_s)
    expect(task.priority).to eq(:low.to_s)
  end

  describe 'Validation' do
    let(:user) {User.create(name: 'test', password: 'test')}
    let(:task) {Task.create(title: 'title', due_date: Time.zone.today, user_id: user.id)}

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
    let(:user) {User.create(name: 'test', password: 'test')}

    before do
      Task.create!(title: 'test1', due_date: '2024-01-01', updated_at: '2024-03-01', status: :open, user_id: user.id)
      Task.create!(title: 'test2', due_date: '2024-03-01', updated_at: '2024-02-01', status: :in_progress, user_id: user.id)
      Task.create!(title: 'test3', due_date: '2024-02-01', updated_at: '2024-01-01', status: :in_progress, user_id: user.id)
      Task.create!(title: 'test11', due_date: '2024-02-01', updated_at: '2024-01-01',status: :in_progress, user_id: user.id)
    end

    it 'search title, result is not empty' do
      task_list = Task.search('test1', nil)
      ## order by created_at desc
      expect(task_list.count).to eq 2
      expect(task_list[0].title).to include('test1')
      expect(task_list[1].title).to include('test1')
    end

    it 'search title, result is empty' do
      task_list = Task.search('test100', nil, user.id)
      expect(task_list.count).to eq 0
    end

    it 'search status, result is not empty' do
      task_list = Task.search(nil, :open, user.id)
      ## order by created_at desc
      expect(task_list.count).to eq 1
      expect(task_list[0]).to have_attributes(status: 'open')
    end

    it 'search status, result is empty' do
      task_list = Task.search(nil, :closed, user.id)
      expect(task_list.count).to eq 0
    end
  end
end
