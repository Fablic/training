# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Label, type: :model do
  describe 'validation' do
    it 'is valid with valid attributes' do
      label = described_class.new(name: 'label1')
      expect(label).to be_valid
    end

    it 'is invalid without name' do
      label = described_class.new(name: nil)
      expect(label).not_to be_valid
    end
  end

  describe 'association' do
    it 'has many tasks' do
      r = described_class.reflect_on_association(:tasks)
      expect(r.macro).to eq(:has_many)
    end

    it 'has many task_labels' do
      r = described_class.reflect_on_association(:task_labels)
      expect(r.macro).to eq(:has_many)
    end
  end
end
