require 'rails_helper'

RSpec.describe User, type: :model do
  subject {
    build(:user)
  }

  context 'with all attributes' do
    it 'is valid' do
      expect(subject).to be_valid
    end
  end

  context 'without email' do
    it 'is invalid' do
      subject.email = nil
      expect(subject).not_to be_valid
    end
  end

  context 'without valid email format' do
    it 'is invalid' do
      subject.email = 'invalid email format'
      expect(subject).not_to be_valid
    end
  end

  context 'without username' do
    it 'is invalid' do
      subject.username = nil
      expect(subject).not_to be_valid
    end
  end

  context 'without password' do
    it 'is invalid' do
      subject.password = nil
      expect(subject).not_to be_valid
    end
  end

  context 'without role' do
    it 'is invalid' do
      subject.role = nil
      expect(subject).not_to be_valid
    end
  end

  context 'when role not in 0, 1' do
    it 'is invalid' do
      expect { subject.role = 2 }.to raise_error(ArgumentError)
    end
  end
end
