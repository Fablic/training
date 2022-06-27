# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  before do
    create(:user)
  end

  describe 'validation test' do
    context 'when valid input' do
      let(:task) { create(:task) }

      it 'addition is success' do
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
