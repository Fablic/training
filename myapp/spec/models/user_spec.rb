require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation' do
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
        create(:user, name: 'Nanashi')

        t = User.new(
          name: 'Nanashi',
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

      it 'failed when it is too short' do
        t = User.new(
          name: 'JohnDoe',
          password: 'Abc123!'
        )
        t.valid?
        expect(t.errors[:password]).to include('は半角英大文字・小文字・数字、シンボルをそれぞれ１文字以上含めてください')
      end

      it 'failed when it is too long' do
        t = User.new(
          name: 'JohnDoe',
          password: 'Abcdefg1234567!?%tltr'
        )
        t.valid?
        expect(t.errors[:password]).to include('は半角英大文字・小文字・数字、シンボルをそれぞれ１文字以上含めてください')
      end
      it 'failed when not containing lowercase' do
        t = User.new(
          name: 'JohnDoe',
          password: 'DUMMYPASSWORD123!?'
        )
        t.valid?
        expect(t.errors[:password]).to include('は半角英大文字・小文字・数字、シンボルをそれぞれ１文字以上含めてください')
      end
      it 'failed when not containing uppercase' do
        t = User.new(
          name: 'JohnDoe',
          password: 'dummypassword123!?'
        )
        t.valid?
        expect(t.errors[:password]).to include('は半角英大文字・小文字・数字、シンボルをそれぞれ１文字以上含めてください')
      end
      it 'failed when not containing digit' do
        t = User.new(
          name: 'JohnDoe',
          password: 'dummyPassword!?'
        )
        t.valid?
        expect(t.errors[:password]).to include('は半角英大文字・小文字・数字、シンボルをそれぞれ１文字以上含めてください')
      end
      it 'failed when not containing symbol' do
        t = User.new(
          name: 'JohnDoe',
          password: 'dummyPassword123'
        )
        t.valid?
        expect(t.errors[:password]).to include('は半角英大文字・小文字・数字、シンボルをそれぞれ１文字以上含めてください')
      end
    end
  end
end
