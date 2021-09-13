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

      context 'greater than 255 characters' do
        let(:name) { 'a' * 256 }
        it { is_expected.to_not be_valid }
      end
    end
  end
end
