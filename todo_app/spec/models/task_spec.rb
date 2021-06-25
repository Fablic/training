require 'rails_helper'

RSpec.describe Task, type: :model do

  describe '#valid?' do
    subject { build(:task, params) }
    let(:params) { { title: title, description: description } }
    let(:random_str) { Faker::Alphanumeric.alphanumeric(number: 10) }

    context 'valid' do
      let(:title) { random_str }
      let(:description) { random_str }

      it { is_expected.to be_valid }
    end

    context 'invalid title' do
      let(:title) { nil }
      let(:description) { random_str }

      it { is_expected.to_not be_valid }
    end
    context 'invalid description' do
      let(:title) { random_str }
      let(:description) { nil }

      it { is_expected.to_not be_valid }
    end
  end

  describe '#scope sort_tasks' do
    subject { Task.sort_tasks(sort) }
    before {
      create(:task, title: 'old', due_date: Faker::Time.backward)
      create(:task, title: 'new', due_date: Faker::Time.forward)
    }
    context 'sort desc' do
      let(:sort) { { due_date: :desc } }
      it {expect(Task.sort_tasks(sort).first.title).to eq('new') }
    end
    context 'sort asc' do
      let(:sort) { { created_at: :asc } }
      it { expect(Task.sort_tasks({created_at: :asc}).first.title).to eq('old') }
    end
  end

  describe '#scope title_search' do
    subject { Task.title_search(search_title) }
    before {
      create(:task, title: 'hoge', due_date: Faker::Time.forward)
      create(:task, title: 'fuga', due_date: Faker::Time.backward)
    }
    context 'when search registered title' do
      let(:search_title) { 'hoge' }
      it 'find record' do
        expect(subject.count).to eq(1)
        expect(subject.first.title).to eq('hoge')
      end
    end
    context 'title is nil' do
      let(:search_title) { nil }
      it 'return all records' do
        expect(subject.count).to eq(2)
      end
    end
  end

  describe '#scope status_search' do
    subject { Task.status_search(search_status) }
    before {
      create(:task, title: 'waiting', due_date: Faker::Time.backward, status: :waiting)
      create(:task, title: 'work_in_progress', due_date: Faker::Time.backward, status: :work_in_progress)
      create(:task, title: 'completed', due_date: Faker::Time.backward, status: :completed)
    }
    context 'when search waiting status' do
      let(:search_status) { [Task.statuses[:waiting]] }
      it 'find waiting task' do
        expect(subject.count).to eq(1)
        expect(subject.first.title).to eq('waiting')
      end
    end
    context 'when search work_in_progress status' do
      let(:search_status) { [Task.statuses[:work_in_progress]] }
      it 'find work_in_progress task' do
        expect(subject.count).to eq(1)
        expect(subject.first.title).to eq('work_in_progress')
      end
    end
    context 'when search completed status' do
      let(:search_status) { [Task.statuses[:completed]] }
      it 'find completed task' do
        expect(subject.count).to eq(1)
        expect(subject.first.title).to eq('completed')
      end
    end
    context 'when status is nil' do
      let(:search_status) { nil }
      it 'return all records' do
        expect(subject.count) .to eq(3)
      end
    end
  end
end
