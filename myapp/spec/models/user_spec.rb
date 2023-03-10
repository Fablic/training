require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation' do
    context 'email validation' do
      let(:user) { FactoryBot.build(:user) }
  
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
