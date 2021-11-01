require 'rails_helper'

RSpec.describe Label, type: :model do
  let!(:label) { create(:label) }

  shared_examples 'When it was invalid.' do
    it 'Invalidated and returns an error message' do
      label.update(column => val)
      expect(label).not_to be_valid
      expect(label.errors.messages).to include(column.to_sym)
      errors.map { |error| expect(label.errors).to be_of_kind(column.to_sym, error.to_sym) }
    end
  end

  describe '#label' do
    let(:column) { 'label' }

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

    context 'When the number of characters in the label is exceeded.' do
      let(:val) { 'a' * 21 }
      let(:errors) { ['too_long'] }
      it_behaves_like 'When it was invalid.'
    end

    context 'When the label is low on characters.' do
      let(:val) { 'a' * 1 }
      let(:errors) { ['too_short'] }
      it_behaves_like 'When it was invalid.'
    end
  end
end
