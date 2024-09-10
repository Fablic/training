require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation test' do
    context 'name column' do
      it 'success' do
        t = User.new(
          name: 'JohnDoe',
          password: 'dummyPassword123!?'
        )
        expect(t).to be_valid
      end

      it 'failed when it is blank' do
        t = User.new(
          name: '',
          password: 'dummyPassword123!?'
        )
        t.valid?
        expect(t.errors[:name]).to include('を入力してください')
      end

      it 'failed when it is too long' do
        t = User.new(
          name: SecureRandom.alphanumeric(21),
        )
        t.valid?
        expect(t.errors[:name]).to include('は20文字以内で入力してください')
      end

      it 'failed when it is already taken' do
        create(:user)

        t = User.new(
          name: 'JohnDoe',
          password: 'dummyPassword123!?'
        )
        t.valid?
        expect(t.errors[:name]).to include('はすでに存在します')
      end
    end

    context 'password column' do
      it 'success' do
        t = User.new(
          name: 'JohnDoe',
          password: 'dummyPassword123!?'
        )
        expect(t).to be_valid
      end

      it 'failed when it is blank' do
        t = User.new(
          name: 'JohnDoe',
          password: ''
        )
        t.valid?
        expect(t.errors[:password]).to include('を入力してください')
      end

      it 'failed when it is too long' do
        t = User.new(
          name: 'JohnDoe',
          password: SecureRandom.alphanumeric(73),
        )
        t.valid?
        expect(t.errors[:password]).to include('は72文字以内で入力してください')
      end
    end
  end
end
