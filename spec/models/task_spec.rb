# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  description :text(65535)
#  name        :string(255)      not null
#  status      :integer          default("ToDo"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_tasks_on_name    (name)
#  index_tasks_on_status  (status)
#
require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task) { build(:task) }

  it { expect(task).to have_attributes(name: 'do homework', description: 'Deadline is August 31.') }

  describe 'validation' do
    it 'is invalid without name' do
      task.name = nil
      task.valid?
      expect(task.errors[:name]).to include('を入力してください')
    end

    it 'is invalid with too long name' do
      task.name = 'a' * 256
      task.valid?
      expect(task.errors[:name]).to include('は255文字以内で入力してください')
    end

    it 'is valid with 255 characters name' do
      task.name = 'a' * 255
      expect(task).to be_valid
    end
  end

  describe 'scope' do
    let!(:important_task) { create(:task, name: '[important]book flight tickets', status: 'ToDo') }
    let!(:completed_task) { create(:task, name: 'completed task', status: 'Done') }

    describe 'by_name' do
      let(:search_name) { 'important' }

      it 'returns a task' do
        expect(Task.by_name(search_name).size).to eq 1
      end

      it 'returns tasks which name include search name' do
        expect(Task.by_name(search_name).sample.name).to include(search_name)
      end
    end

    describe 'by_status' do
      let(:search_status) { 'Done' }

      it 'returns a task' do
        expect(Task.by_status(search_status).size).to eq 1
      end

      it 'returns tasks which status equal search status' do
        expect(Task.by_status(search_status).sample.status).to eq (search_status)
      end
    end
  end
end
