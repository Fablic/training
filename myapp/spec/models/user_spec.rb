require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user_valid) {
    FactoryBot.build(:user, id: 1)
  }

  context 'emailのバリデーション' do
    it 'emailの長さが256文字以上だと無効' do
      user_valid.email = 'a' * 256
      expect(user_valid).not_to be_valid
    end

    it '同じものが2つ以上あると無効' do
      user_exist = FactoryBot.create(:user, email: 'fuga@example.com')
      user_valid.email = user_exist.email
      expect(user_valid).not_to be_valid
    end

    it '@から始まるものは無効' do
      user_valid.email = '@example.com'
      expect(user_valid).not_to be_valid
    end

    it '@がないものは無効' do
      user_valid.email = 'hugaexample.com'
      expect(user_valid).not_to be_valid
    end

    it '2次ドメインが入っていないものは無効' do
      user_valid.email = 'huga@.com'
      expect(user_valid).not_to be_valid
    end

    it 'ドットがないものは無効' do
      user_valid.email = 'huga@examplecom'
      expect(user_valid).not_to be_valid
    end

    it 'トップレベルドメインがないものは無効' do
      user_valid.email = 'huga@example.'
      expect(user_valid).not_to be_valid
    end
  end

  context '外部キー制約' do
    it 'ユーザーを削除した時にタスクも削除される' do
      user = FactoryBot.create(:user)
      task = FactoryBot.create(:task, user_id: user.id)
      User.destroy(user.id)
      expect(Task.find_by(id: task.id)).to be_nil
    end
  end
end
