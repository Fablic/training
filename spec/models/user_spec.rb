require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'init factories user' do
    let(:user) { create(:user) }

    it 'expected attributes' do
      expect(user).
        to have_attributes(
             name: 'test',
             email: 'test@example.com',
             password: 'password'
           )
    end
  end
end
