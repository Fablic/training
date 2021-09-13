require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションのテスト' do
    context 'name空ではない' do
      it 'バリデーションエラーにならないこと' do
        user = build(:user)
        expect(user).to be_valid
      end
    end
    context 'nameが空' do
      it 'バリデーションエラーになること' do
        user = build(:user, name: nil)
        expect(user.valid?).to eq false
        expect(user.errors.full_messages).to include('Nameを入力してください')
      end
    end
    context 'passwordが空' do
      it 'バリデーションエラーになること' do
        user = build(:user, password: nil)
        expect(user.valid?).to eq false
        expect(user.errors.full_messages).to include('Passwordを入力してください')
      end
    end
  end
end
