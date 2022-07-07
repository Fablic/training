# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  before do
    create(:user)
  end

  describe '#name' do
    context 'when entering valid input' do
      it 'addition is success' do
        task = build(:task, name: 'テストタスク')
        expect(task).to be_valid
      end
    end

    context 'when entering invalid input' do
      it 'failure if nil' do
        task = build(:task, name: nil)
        expect(task.valid?).to be false
      end

      it 'failure if less than 2 characters' do
        task = build(:task, name: 't')
        expect(task.valid?).to be false
      end

      it 'failure if more than 32 characters' do
        task = build(:task, name: 'test-input-case-it-is-more-than-32-characters')
        expect(task.valid?).to be false
      end
    end
  end

  describe '#scope' do
    let(:task1) { create(:task, name: 'テスト11', status: 'TODO', limit: Time.new(2021, 1, 10).in_time_zone, created_at: Time.new(2021, 12, 1).in_time_zone) }
    let(:task2) { create(:task, name: 'テスト21', status: 'IN_PROGRESS', limit: Time.new(2021, 1, 2).in_time_zone, created_at: Time.new(2021, 12, 2).in_time_zone) }
    let(:task3) { create(:task, name: 'テスト31', status: 'DONE', limit: Time.new(2021, 1, 3).in_time_zone, created_at: Time.new(2021, 12, 3).in_time_zone) }

    describe ':sortby' do
      context 'when specify the limit column and asc direction' do # rubocop:disable RSpec/NestedGroups
        it 'sorted by limit asc' do
          expect(Task.sortby('limit', 'asc')).to eq [task2, task3, task1]
        end
      end

      context 'when specify the limit column and desc direction' do # rubocop:disable RSpec/NestedGroups
        it 'sorted by limit desc' do
          expect(Task.sortby('limit', 'desc')).to eq [task1, task3, task2]
        end
      end

      context 'when specify the created_at column and asc direction' do # rubocop:disable RSpec/NestedGroups
        it 'sorted by creation date asc' do
          expect(Task.sortby('created_at', 'asc')).to eq [task1, task2, task3]
        end
      end

      context 'when specify the created_at column and desc direction' do # rubocop:disable RSpec/NestedGroups
        it 'sorted by creation date desc' do
          expect(Task.sortby('created_at', 'desc')).to eq [task3, task2, task1]
        end
      end
    end

    describe ':name_or_description' do
      it 'searched by name or description' do
        expect(Task.search_by_name_or_description('テスト11')).to eq [task1]
      end

      it 'searched by name in forward matching' do
        expect(Task.search_by_name_or_description('テスト2')).to eq [task2]
      end
    end

    describe ':status' do
      it 'searched by status' do
        expect(Task.search_by_status('DONE')).to eq [task3]
      end
    end
  end
end
