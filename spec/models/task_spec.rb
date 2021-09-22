require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'init factories task' do
    let(:task) { create(:task) }

    it 'expected attributes' do
      expect(task).to have_attributes(name: 'task 1', description: 'task 1 description')
    end

    it 'expected enum value' do
      expect(task.priority).to eq("low")
    end
  end

  describe 'validation' do
    let(:name) { 'task' }
    let(:description) { 'task description' }
    let(:priority) { 'low' }

    subject { build(:task, name: name, description: description, priority: priority)}

    context 'valid' do
      it { is_expected.to be_valid }
    end

    describe 'attribute: name' do
      context 'nil' do
        let(:name) { nil }
        it { is_expected.to_not be_valid }
      end

      context 'greater than 255 half-width characters' do
        let(:name) { 'a' * 256 }
        it { is_expected.to_not be_valid }
      end

      context 'greater than 255 full-width characters' do
        let(:name) { 'あ' * 256 }
        it { is_expected.to_not be_valid }
      end

      context '255 half-width characters' do
        let(:name) { 'a' * 255 }
        it { is_expected.to be_valid }
      end

      context '255 full-width characters' do
        let(:name) { 'あ' * 255 }
        it { is_expected.to be_valid }
      end
    end
  end

  describe 'search scope' do
    let!(:todo_task) { create(:task) } # name: task 1, description: task 1 description, status: todo
    let!(:done_task) { create(:task_2) } # name: task 2, description: task 2 description, status: done

    describe 'search by name' do
      subject { Task.search_by_name(keyword) }

      context 'blank keyword' do
        let(:keyword) { '' }
        it { is_expected.to include(todo_task, done_task) }
      end

      context 'search by (task 1) keyword' do
        let(:keyword) { 'task 1' }
        it { is_expected.to include(todo_task) }
        it { is_expected.to_not include(done_task) }
      end
    end

    context 'search by status' do
      subject { Task.search_by_status(status) }

      context 'search by all status' do
        let(:status) { %w[todo in_progress done] }
        it { is_expected.to include(todo_task, done_task) }
      end

      context 'search done task' do
        let(:status) { 'done' }
        it { is_expected.to include(done_task) }
        it { is_expected.to_not include(todo_task) }
      end
    end
  end
end
