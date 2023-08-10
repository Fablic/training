require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    context 'when valid' do
      it 'is valid with valid attributes' do
        user = build(:user)
        expect(user).to be_valid
      end
    end

    context 'when invalid' do
      shared_examples 'an invalid user' do |attribute, error_message|
        it "is not valid without #{attribute}" do
          user[attribute] = nil
          expect(user).not_to be_valid
          expect(user.errors[attribute]).to include(error_message)
        end
      end

      let(:user) { build(:user) }

      include_examples 'an invalid user', :first_name, "can't be blank"
      include_examples 'an invalid user', :username, "can't be blank"
      include_examples 'an invalid user', :email, "can't be blank"
      include_examples 'an invalid user', :password, "can't be blank"
    end
  end
end
