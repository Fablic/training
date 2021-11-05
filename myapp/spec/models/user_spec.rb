# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User', type: :model do
  describe '#name' do
    context 'when name is empty' do
      it 'is invalid' do
        user = build(:user, name: '')
        user.valid?
        expect(user.errors[:name]).to include('を入力してください')
      end
    end

    context 'when same name already exists' do
      before { create(:user, name: 'namae') }

      it 'is invalid' do
        user = build(:user, name: 'namae')
        user.valid?
        expect(user.errors[:name]).to include('はすでに存在します')
      end
    end
  end

  describe '#password_digest' do
    context 'when password is empty' do
      it 'is invalid' do
        user = build(:user, password_digest: '')
        user.valid?
        expect(user.errors[:password]).to include('を入力してください')
      end
    end
  end

  describe '#is_admin' do
    context 'when input 0' do
      let!(:user) { create(:user, is_admin: 0) }

      it 'create success as a false' do
        expect(user).to be_valid
      end
    end

    context 'when input 1' do
      let!(:user) { create(:user, is_admin: 1) }

      it 'create success as a true' do
        expect(user).to be_valid
      end
    end
  end
end
