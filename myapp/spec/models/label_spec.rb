require 'rails_helper'

RSpec.describe Label, type: :model do
  describe 'バリデーションテスト' do
    let(:label) { build(:label) }

    context 'タグ名を入力するとき' do
      it '正常に登録できる' do
        label = build(:label)

        expect(label).to be_valid
      end
    end

    context 'nameのバリデーション' do
      it 'nameが空欄だと無効' do
        label.name = ''

        expect(label).not_to be_valid
        expect(label.errors.full_messages).to include('ラベルを入力してください')
      end

      it '同じものが2つ以上あると無効' do
        label_exist = create(:label, name: 'foo')
        label.name = label_exist.name

        expect(label).not_to be_valid
        expect(label.errors.full_messages).to include('ラベルはすでに存在します')
      end
    end
  end
end
