require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe '#name' do
    it 'cannot create a record without name' do
      user.name = ''
      expect(user).not_to be_valid
      expect(user.errors.messages[:name]).to eq(['Name must be filled in'])
    end

    it 'cannot create a record with the same name' do
      user.name = 'foo'
      user.save!
      new_user = build(:user, name: 'foo')
      expect(new_user).not_to be_valid
      expect(new_user.errors.messages[:name]).to eq(['The same name has already been taken'])
    end
  end

  describe '#password' do
    it 'cannot create a record without password' do
      user.password = nil
      expect(user).not_to be_valid
      expect(user.errors.messages[:password]).to eq(["Password can't be blank"])
    end
  end
end
