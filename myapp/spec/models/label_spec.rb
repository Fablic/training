require 'rails_helper'

RSpec.describe Label, type: :model do
  describe 'バリデーションのテスト' do
    context 'nameが空ではない' do
      it 'バリデーションエラーにならないこと' do
        label = build(:label)
        expect(label).to be_valid
      end
    end
    context 'nameが空' do
      it 'バリデーションエラーになること' do
        label = build(:label, name: nil)
        expect(label.valid?).to eq false
        expect(label.errors.full_messages).to include('Nameを入力してください')
      end
    end
  end
end
