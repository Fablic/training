# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaskLabel, type: :model do
  describe 'association' do
    it 'belongs to task' do
      r = described_class.reflect_on_association(:task)
      expect(r.macro).to eq(:belongs_to)
    end

    it 'belongs to label' do
      r = described_class.reflect_on_association(:label)
      expect(r.macro).to eq(:belongs_to)
    end

    it 'is successfully deleted when a parent task is deleted' do
      task = FactoryBot.create(:task)
      label = FactoryBot.create(:label)
      task_label = described_class.create(task_id: task.id, label_id: label.id)
      task.destroy!
      expect(described_class.find_by(id: task_label.id)).to eq nil
    end
  end
end
