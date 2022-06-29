# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  before do
    create(:user)
  end

  describe '#name' do
    context 'when valid input' do
      it 'addition is success' do
        task = build(:task, name: 'テストタスク')
        expect(task).to be_valid
      end
    end

    context 'when entering title column' do
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
end
