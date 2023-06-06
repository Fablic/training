require 'rails_helper'

RSpec.describe Label, type: :model do
  describe 'バリデーションテスト' do
    let(:label) { build(:label) }

    context 'タグ名を入力するとき' do
      it '正常に登録できる' do
        label = build(:label)

        expect(label).to be_valid
      end

      it 'nameが20文字以内なら正常に登録できる' do
        label.name = 'a' * 20

        expect(label).to be_valid
      end
    end

    context 'nameのバリデーション' do
      it 'nameが空欄だと無効' do
        label.name = ''

        expect(label).not_to be_valid
        expect(label.errors.full_messages).to include('ラベルを入力してください')
      end

      it 'nameが21文字以上だと無効' do
        label.name = 'a' * 21

        expect(label).not_to be_valid
        expect(label.errors.full_messages).to include('ラベルは20文字以内で入力してください')
      end

      it '同じラベル名が2つ以上あると無効' do
        label_exist = create(:label, name: 'foo')
        label.name = label_exist.name

        expect(label).not_to be_valid
        expect(label.errors.full_messages).to include('ラベルはすでに存在します')
      end
    end
  end

  describe '外部キー制約のテスト' do
    let!(:user) { create(:user) }
    let!(:label) { create(:label, user: user) }
    let!(:task) { create(:task, user_id: user.id, labels: [label]) }

    context 'ユーザーを削除したとき' do
      it '関連ラベルも削除される' do
        User.destroy(user.id)

        expect(Task.find_by(id: task.id)).to be_nil
        expect(Label.find_by(id: label.id)).to be_nil
      end
    end
  end
end
