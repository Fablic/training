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
   let!(:old_task) { create(:task, due_date: Faker::Time.backward) }
   let!(:new_task) { create(:task, due_date: Faker::Time.forward) }
 
     context 'sort desc' do
       it {expect(Task.sort_tasks({due_date: :desc}).first).to eq(task2) }
     end
     context 'sort asc' do
      it { expect(Task.sort_tasks({created_at: :asc}).first).to eq(task1) }
     end
   end
end
