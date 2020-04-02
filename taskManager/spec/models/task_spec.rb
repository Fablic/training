require 'rails_helper'

RSpec.describe Task, type: :model do

  let(:summary)     { 'task1' }
  let(:description) { 'this is 1st valid task' }
  let(:status)      { 1 }
  let(:priority)    { 1 }
  let(:due)         { Time.zone.now }
  let(:user)        { create(:user) }
  subject { Task.new(summary: summary, description: description, status: status, priority: priority, due: due, user: user )  }

  describe '#create' do
    describe 'validate summary' do
      context 'when max length' do
        let(:summary) { 'T' * 50 }
        it { is_expected.to be_valid }
      end

      context 'when over length' do
        let(:summary) { 'T' * 51 }
        it { expect(subject).to be_invalid }
      end

      context 'when null' do
        let(:summary) { nil }
        it { expect(subject).to be_invalid }
      end
    end

    describe 'validate description' do
      context 'when max length' do
        let(:description) { 'T' * 255 }
        it { is_expected.to be_valid }
      end

      context 'when over length' do
        let(:description) { 'T' * 256 }
        it { is_expected.to be_invalid }
      end

      context 'when null' do
        let(:description) { nil }
        it { is_expected.to be_valid }
      end
    end

    describe 'validate status' do
      context 'when valid value' do
        status = Task.statuses
        status.each do |k, v|
          let(:status) { v }
          it { is_expected.to be_valid }
        end
      end

      context 'when null' do
        let(:status) { nil }
        it { is_expected.to be_invalid }
      end
    end

    describe 'validate priority' do
      context 'when valid value' do
        priority = Task.priorities
        priority.each do |k, v|
          let(:priority) { v }
          it { is_expected.to be_valid }
        end
      end

      context 'when null' do
        let(:priority) { nil }
        it { is_expected.to be_invalid }
      end
    end

    describe 'validate due' do
      context 'when valid value' do
        let(:due) { Time.zone.local(2100, 12, 31, 0, 0) }
        it { is_expected.to be_valid }
      end

      context 'when past time' do
        let(:due) { Time.zone.yesterday }
        it { is_expected.to be_invalid }
      end

      context 'when null' do
         it { is_expected.to be_valid }
      end
    end
  end

  describe 'search' do
    let!(:task1) {create(:task1, summary: 'hoge') }
    let!(:task2) {create(:task2, summary: 'fuga') }
    let!(:task3) {create(:task3, summary: 'piyo') }
    let(:sort_column) { :due }
    context 'when searching with summary' do
      it 'is record found' do
        tasks = Task.search({summary: 'fuga', status: nil, label: '' })
        expect(tasks.size).to eq (1)
        expect(tasks).to include(task2)
      end

      it 'is record not found ' do
        tasks = Task.search({summary: 'fuge', status: nil, label: ''})
        expect(tasks.size).to eq (0)
      end
    end

    context 'when searching with status' do
      it 'is record found' do
        tasks = Task.search({summary: nil, status: 5, label: ''})
        expect(tasks.size).to eq (1)
        expect(tasks).to include(task3)
      end

      it 'is record not found' do
        tasks = Task.search({summary: nil, status: 4, label: ''})
        expect(tasks.size).to eq (0)
      end
    end

    context 'when searching with summary and status' do
      it 'is record found' do
        tasks = Task.search({summary: 'hoge', status: 1, label: ''})
        expect(tasks.size).to eq (1)
        expect(tasks).to include(task1)
      end

      it 'is record not found' do
        tasks = Task.search({summary: 'hoge', status: 3, label: ''})
        expect(tasks.size).to eq (0)
      end
    end
  end
end
