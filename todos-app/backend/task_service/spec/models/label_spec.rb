# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Label, type: :model do
  subject {
    build(:label)
  }

  context 'with all attributes' do
    it 'is valid' do
      expect(subject).to be_valid
    end
  end

  context 'without name' do
    it 'is invalid' do
      subject.name = nil
      expect(subject).not_to be_valid
    end
  end

  context 'when name has a whitespace' do
    it 'is invalid' do
      subject.name = 'some name'
      expect(subject).not_to be_valid
    end
  end

  context 'without user_id' do
    it 'is invalid' do
      subject.user_id = nil
      expect(subject).to be_invalid
    end
  end

  context 'with duplicate user_id and name' do
    it 'is invalid' do
      described_class.create(user_id: 1, name: 'name')
      label = described_class.create(user_id: 1, name: 'name')
      expect(label).to be_invalid
    end
  end
end
