require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) {
    build(:user, id: 1)
  }

  context 'emailのバリデーション' do
    it 'emailの長さが256文字以上だと無効' do
      user.email = 'a' * 256
      expect(user).not_to be_valid
    end

    it '同じものが2つ以上あると無効' do
      user_exist = create(:user, email: 'fuga@example.com')
      user.email = user_exist.email
      expect(user).not_to be_valid
    end

    it '@から始まるものは無効' do
      user.email = '@example.com'
      expect(user).not_to be_valid
    end

    it '@がないものは無効' do
      user.email = 'hugaexample.com'
      expect(user).not_to be_valid
    end

    it '2次ドメインが入っていないものは無効' do
      user.email = 'huga@.com'
      expect(user).not_to be_valid
    end

    it 'ドットがないものは無効' do
      user.email = 'huga@examplecom'
      expect(user).not_to be_valid
    end

    it 'トップレベルドメインがないものは無効' do
      user.email = 'huga@example.'

      expect(user).not_to be_valid
    end
  end

  context '外部キー制約' do
    it 'ユーザーを削除した時にタスクも削除される' do
      user = create(:user)
      task = create(:task, user_id: user.id)

      User.destroy(user.id)

      expect(Task.find_by(id: task.id)).to be_nil
    end
  end
end
