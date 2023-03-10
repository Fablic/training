require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:tasks).dependent(:destroy) }
  end

  describe 'validation' do
    context 'name' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_length_of(:name).is_at_most(255) }
    end

    context 'encrypted_password' do
      it { is_expected.to validate_presence_of(:encrypted_password) }
    end

    context 'email' do
      let(:user) { FactoryBot.build(:user) }
  
      it { is_expected.to validate_presence_of(:email) }

      it 'with valid parameters' do
        user.email = 'test@rakuten.com'
        expect(user).to be_valid
      end

      it 'with invalid parameters(lack of @)' do
        user.email = 'testrakuten.com'
        expect(user).to be_invalid
      end

      it 'with invalid parameters(invalid space)' do
        user.email = 'test@ rakuten.com'
        expect(user).to be_invalid
      end

    end
  end

  describe 'md5_converter' do
    it 'return md5 string' do
      expect(User::md5_converter('aaa')).to match(/\A[a-z0-9]+\z/)
    end
  end
end
