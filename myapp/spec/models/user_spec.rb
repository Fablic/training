require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションのテスト' do
    let(:user) {
      build(:user)
    }

    context '全て入力したとき' do
      it '正常に登録できる' do
        expect(user).to be_valid
      end
    end

    context 'nameのバリデーション' do
      it 'nameが空欄だと無効' do
        user.name = ''

        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include('Nameを入力してください')
      end
    end

    context 'emailのバリデーション' do
      it 'emailが空欄だと無効' do
        user.email = ''

        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include('Emailを入力してください', 'Emailは不正な値です')
      end

      it 'emailの長さが256文字以上だと無効' do
        text = 'a' * 256
        user.email = "#{text}" + '@example.com'

        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include('Emailは255文字以内で入力してください')
      end

      it '同じものが2つ以上あると無効' do
        user_exist = create(:user, email: 'fuga@example.com')
        user.email = user_exist.email

        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include('Emailはすでに存在します')
      end

      it '@から始まるものは無効' do
        user.email = '@example.com'

        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include('Emailは不正な値です')
      end

      it '@がないものは無効' do
        user.email = 'hugaexample.com'

        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include('Emailは不正な値です')
      end

      it '2次ドメインが入っていないものは無効' do
        user.email = 'huga@.com'

        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include('Emailは不正な値です')
      end

      it 'ドットがないものは無効' do
        user.email = 'huga@examplecom'

        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include('Emailは不正な値です')
      end

      it 'トップレベルドメインがないものは無効' do
        user.email = 'huga@example.'

        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include('Emailは不正な値です')
      end
    end
  end

  describe '外部キー制約のテスト' do
    context 'ユーザーを削除したとき' do
      it '関連タスクも削除される' do
        user = create(:user)
        task = create(:task, user_id: user.id)

        User.destroy(user.id)

        expect(Task.find_by(id: task.id)).to be_nil
      end
    end
  end
end
