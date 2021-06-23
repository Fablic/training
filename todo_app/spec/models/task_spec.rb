require 'rails_helper'

RSpec.describe Task, type: :model do
  let!(:old_task) { create(:task, due_date: Faker::Time.backward, status: :work_in_progress) }
  let!(:new_task) { create(:task, due_date: Faker::Time.forward) }
  let!(:completed_task) { create(:task, due_date: new_task.due_date.yesterday, status: :completed) }
  let(:waiting) { [Task.statuses[:waiting]] }
  let(:work_in_progress) { [Task.statuses[:work_in_progress]] }
  let(:completed) { [Task.statuses[:completed]] }


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
  context 'sort desc' do
      it {expect(Task.sort_tasks({due_date: :desc}).first).to eq(new_task) }
    end
    context 'sort asc' do
     it { expect(Task.sort_tasks({created_at: :asc}).first).to eq(old_task) }
    end
  end

  describe '#scope title_search' do
    context 'title exists' do
      subject { Task.title_search(new_task.title) }
      it 'find record' do
        expect(subject.count).to eq(1)
        expect(Task.title_search(new_task.title).first).to eq(new_task)
      end
    end
    context 'title is nil' do
      it 'find record' do
        expect(Task.title_search(nil).to eq(3)
      end
    end
  end

  describe '#scope status_search' do
    context 'waiting' do
      subject { Task.status_search(waiting) }
      it 'find new_task task' do
        expect(subject.count).to eq(1)
        expect(subject.first).to eq(new_task)
      end
    end
    context 'work_in_progress' do
      subject { Task.status_search(work_in_progress) }
      it 'find old task' do
        expect(subject.count).to eq(1)
        expect(subject.first).to eq(old_task)
      end
    end
    context 'completed' do
      subject { Task.status_search(completed) }
      it 'find completed_task task' do
        expect(subject.count).to eq(1)
        expect(subject.first).to eq(completed_task)
      end
    end
    context 'status is nil' do
      it 'find record' do
        expect(Task.status_search(nil).count) .to eq(3)
      end
    end
  end
end
