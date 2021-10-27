require 'rails_helper'

RSpec.describe Task, type: :model do
  let!(:user) { create(:user) }
  let(:task) { create(:task, user: user) }

  shared_examples 'When it was invalid.' do
    it 'Invalidated and returns an error message' do
      task.update(column => val)
      expect(task).not_to be_valid
      expect(task.errors.messages).to include(column.to_sym)
      errors.map { |error| expect(task.errors).to be_of_kind(column.to_sym, error.to_sym) }
    end
  end

  shared_examples 'When it was valid.' do
    it 'Invalidated and returns an error message' do
      task.update(column => val)
      expect(task).to be_valid
      expect(task.errors.messages).not_to include(column.to_sym)
    end
  end

  describe '#title' do
    let(:column) { 'title' }

    context 'When nil is set.' do
      let(:val) { nil }
      let(:errors) { %w[blank too_short] }
      it_behaves_like 'When it was invalid.'
    end

    context 'When empty is set.' do
      let(:val) { '' }
      let(:errors) { %w[blank too_short] }
      it_behaves_like 'When it was invalid.'
    end

    context 'When the number of characters in the title is exceeded.' do
      let(:val) { 'a' * 21 }
      let(:errors) { ['too_long'] }
      it_behaves_like 'When it was invalid.'
    end

    context 'When the title is low on characters.' do
      let(:val) { 'a' * 2 }
      let(:errors) { ['too_short'] }
      it_behaves_like 'When it was invalid.'
    end
  end

  describe '#detail' do
    let(:column) { 'detail' }

    context 'When nil is set.' do
      let(:val) { nil }
      it_behaves_like 'When it was valid.'
    end

    context 'When empty is set.' do
      let(:val) { '' }
      it_behaves_like 'When it was valid.'
    end

    context 'When the number of characters in the title is exceeded.' do
      let(:val) { 'a' * 10_001 }
      let(:errors) { ['too_long'] }
      it_behaves_like 'When it was invalid.'
    end
  end

  describe '#due_date' do
    let(:column) { 'due_date' }

    context 'When nil is set.' do
      let(:val) { nil }
      let(:errors) { %w[blank] }
      it_behaves_like 'When it was invalid.'
    end

    context 'When empty is set.' do
      let(:val) { '' }
      let(:errors) { %w[blank] }
      it_behaves_like 'When it was invalid.'
    end

    context 'When today is set' do
      let(:val) { Time.zone.now }
      it_behaves_like 'When it was valid.'
    end

    context 'When tomorrow is set' do
      let(:val) { Time.zone.tomorrow }
      it_behaves_like 'When it was valid.'
    end

    context 'When yesterday is set' do
      let(:val) { Time.zone.yesterday }
      let(:errors) { %w[error] }
      it_behaves_like 'When it was invalid.'
    end
  end

  describe '#priority' do
    let(:column) { 'priority' }

    context 'When nil is set.' do
      let(:val) { nil }
      let(:errors) { %w[blank] }
      it_behaves_like 'When it was invalid.'
    end

    context 'When unintended value  is set' do
      let(:val) { [*0..100].delete_if { |n| Task.prioritys.values.include?(n) }.sample }
      let(:errors) { %w[inclusion] }
      it_behaves_like 'When it was invalid.'
    end
  end

  describe '#status' do
    let(:column) { 'status' }

    context 'When nil is set.' do
      let(:val) { nil }
      let(:errors) { %w[blank] }
      it_behaves_like 'When it was invalid.'
    end

    context 'When unintended value  is set' do
      let(:val) { [*0..100].delete_if { |n| Task.statuses.values.include?(n) }.sample }
      let(:errors) { %w[inclusion] }
      it_behaves_like 'When it was invalid.'
    end
  end
end
