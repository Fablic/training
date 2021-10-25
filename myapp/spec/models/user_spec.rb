require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }

  shared_examples 'When it was invalid.' do
    it 'Invalidated and returns an error message' do
      user.send("#{column}=", val)
      expect(user).not_to be_valid
      expect(user.errors.messages).to include(column.to_sym)
    end
  end

  shared_examples 'When it was valid.' do
    it 'Invalidated and returns an error message' do
      user.send("#{column}=", val)
      expect(user).to be_valid
      expect(user.errors.messages).not_to include(column.to_sym)
    end
  end

  describe '#name' do
    let(:column) { 'name' }

    context 'When nil is set.' do
      let(:val) { nil }
      it_behaves_like 'When it was invalid.'
    end

    context 'When empty is set.' do
      let(:val) { '' }
      it_behaves_like 'When it was invalid.'
    end

    context 'When the number of characters in the title is exceeded.' do
      let(:val) { 'a' * 21 }
      it_behaves_like 'When it was invalid.'
    end

    context 'When the title is low on characters.' do
      let(:val) { 'a' * 2 }
      it_behaves_like 'When it was invalid.'
    end
  end
end
