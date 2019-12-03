# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:title) { 'title' }
  let(:status) { :todo }
  let(:description) { 'a' * 250 }
  let(:due_date) { Time.zone.local(2100, 12, 31, 0, 0) }
  subject { Task.new(title: title, description: description, status: status, due_date: due_date) }

  describe 'when valid' do
    context 'with valid attributes' do
      it { expect(subject).to be_valid }
    end

    context 'with a max-length title' do
      let(:title) { 'a' * 250 }
      it { expect(subject).to be_valid }
    end

    context 'with a valid status' do
      let(:status) { :done }
      it { expect(subject).to be_valid }
    end

    context 'with a due_date today' do
      let(:due_date) { Time.zone.now }
      it { expect(subject).to be_valid }
    end
  end

  describe 'when not valid' do
    context 'without a title' do
      let(:title) { nil }
      it { expect(subject).not_to be_valid }
    end

    context 'with a title over max length' do
      let(:title) { 'a' * 251 }
      it { expect(subject).not_to be_valid }
    end

    context 'with a past due_date' do
      let(:due_date) { Time.zone.now.yesterday }
      it { expect(subject).to_not be_valid }
    end
  end

  describe 'when search' do
    let!(:task1) { Task.create(title: 'タスク１', description: 'タスク１詳細', status: Task.statuses[:todo], due_date: Time.zone.local(2020, 1, 1, 0, 0)) }
    let!(:task2) { Task.create(title: 'タスク２', description: 'タスク２詳細', status: Task.statuses[:doing], due_date: Time.zone.local(2021, 1, 1, 0, 0)) }
    let(:sort_column) { :due_date }

    context 'find' do
      it 'with a title' do
        tasks = Task.search({ title: 'タスク２', status: nil }, sort_column)
        expect(tasks.size).to eq(1)
        expect(tasks).to include(task2)
      end

      it 'with a status' do
        tasks = Task.search({ title: nil, status: Task.statuses[:doing] }, sort_column)
        expect(tasks.size).to eq(1)
        expect(tasks).to include(task2)
      end

      it 'with no conditions' do
        tasks = Task.search({ title: nil, status: nil }, sort_column)
        expect(tasks.size).to eq(2)
        expect(tasks).to include(task1, task2)
      end
    end

    context 'not find' do
      it 'with a title' do
        tasks = Task.search({ title: 'タスク３', status: nil }, sort_column)
        expect(tasks.size).to eq(0)
      end

      it 'with a status' do
        tasks = Task.search({ title: nil, status: Task.statuses[:done] }, sort_column)
        expect(tasks.size).to eq(0)
      end
    end
  end
end
