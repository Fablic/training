require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'UserModelのバリデーションチェック' do
    let(:user) { create(:user) }
    let(:user_valid) { user.valid? }

    context 'nameの値が空欄の時' do
      it 'バリデーションがFalseになる事' do
        user.name = ''
        expect(user_valid).to eq false
      end
    end

    context 'nameの値がnilの時' do
      it 'バリデーションがFalseになる事' do
        user.name = nil
        expect(user_valid).to eq false
      end
    end

    context 'nameの値が56文字以上の時' do
      it 'バリデーションがFalseになる事' do
        user.name = Faker::Lorem.characters(number: 56)
        expect(user_valid).to eq false
      end
    end
  end
end
