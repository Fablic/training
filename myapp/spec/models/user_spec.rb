require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user_valid) do
    FactoryBot.build(:user, id: 1)
  end
  context 'emailのバリデーション' do
    example 'emailの長さが256文字以上だと無効' do
      user_valid.email = 'a' * 256
      expect(user_valid).not_to be_valid
    end

    example '同じものが2つ以上あると無効' do
      user_exist = FactoryBot.create(:user, email: 'fuga@example.com')
      user_valid.email = user_exist.email
      expect(user_valid).not_to be_valid
    end

    example 'アットマークから始まるものは無効' do
      user_valid.email = '@example.com'
      expect(user_valid).not_to be_valid
    end

    example 'アットマークがないものは無効' do
      user_valid.email = 'hugaexample.com'
      expect(user_valid).not_to be_valid
    end

    example '2次ドメインが入っていないものは無効' do
      user_valid.email = 'huga@.com'
      expect(user_valid).not_to be_valid
    end

    example 'ドットがないものは無効' do
      user_valid.email = 'huga@examplecom'
      expect(user_valid).not_to be_valid
    end

    example 'トップレベルドメインがないものは無効' do
      user_valid.email = 'huga@example.'
      expect(user_valid).not_to be_valid
    end
  end

  context '外部キー制約' do
    example 'ユーザーを削除した時にタスクも削除される' do
      user = FactoryBot.create(:user)
      task = FactoryBot.create(:task, user_id: user.id)
      User.destroy(user.id)
      expect(Task.find_by(id: task.id)).to be_nil
    end
  end
end
