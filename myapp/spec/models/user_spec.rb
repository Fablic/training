require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }

  shared_examples 'When it was invalid.' do
    it 'Invalidated and returns an error message' do
      user.update_attributes({column.to_sym => val})
      expect(user).not_to be_valid
      expect(user.errors.messages).to include(column.to_sym)
      errors.map { |error| expect(user.errors).to be_of_kind(column.to_sym, error.to_sym) }
    end
  end

  shared_examples 'When it was valid.' do
    it 'Invalidated and returns an error message' do
      user.update_attributes({column.to_sym => val})
      expect(user).to be_valid
      expect(user.errors.messages).not_to include(column.to_sym)
    end
  end

  describe '#name' do
    let(:column) { 'name' }

    context 'When the correct value is entered.' do
      let(:val) { 'ABCDEF' }
      it_behaves_like 'When it was valid.'
    end

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
end
