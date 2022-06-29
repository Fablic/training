# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    create(:user, name: 'hoge', email: 'hoge@gmail.com', password: 'password')
  end

  describe '#name' do
    context 'when entering valid input' do
      it 'addition is success' do
        user = build(:user, name: 'test-user')
        expect(user).to be_valid
      end
    end

    context 'when entering invalid input' do
      it 'failure if nil' do
        user = build(:user, name: nil)
        expect(user.valid?).to be false
      end

      it 'failure if more than 30 characters' do
        user = build(:user, name: 'test-input-case-it-is-more-than-30-characters')
        expect(user.valid?).to be false
      end

      it 'failure if uon-unique' do
        user = build(:user, name: 'hoge')
        expect(user.valid?).to be false
      end
    end
  end

  describe '#email' do
    context 'when entering valid input' do
      it 'addition is success' do
        user = build(:user, email: 'test@gmail.com')
        expect(user).to be_valid
      end
    end

    context 'when entering invalid input' do
      it 'failure if nil' do
        user = build(:user, email: nil)
        expect(user.valid?).to be false
      end

      it 'failure if non-email format' do
        user = build(:user, email: 'test.com')
        expect(user.valid?).to be false
      end

      it 'failure if non-unique' do
        user = build(:user, email: 'hoge@gmail.com')
        expect(user.valid?).to be false
      end
    end
  end

  describe '#password' do
    context 'when entering valid input' do
      it 'addition is success' do
        user = build(:user, password: 'p@ssword')
        expect(user).to be_valid
      end
    end

    context 'when entering invalid input' do
      it 'failure if nil' do
        user = build(:user, password: nil)
        expect(user.valid?).to be false
      end

      it 'failure if less than 8 characters' do
        user = build(:user, password: 'pass')
        expect(user.valid?).to be false
      end
    end
  end
end
