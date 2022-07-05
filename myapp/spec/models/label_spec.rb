require 'rails_helper'

RSpec.describe Label, type: :model do
  let(:user) do
    FactoryBot.create(:user)
  end

  example 'nameの長さが17文字以上だと無効' do
    label_long = FactoryBot.build(:label, name: 'a' * 17)
    expect(label_long).not_to be_valid
  end

  example 'nameが空白だと無効' do
    label_space = FactoryBot.build(:label, name: ' ')
    expect(label_space).not_to be_valid
  end

  describe 'リレーション' do
    context 'ユーザーにラベルが登録されているとき' do
      example 'ラベルを削除すると中間テーブルも削除される' do
        task_with_label = FactoryBot.create(:task, :with_label, user_id: user.id)
        Label.destroy(task_with_label.labels[0].id)
        expect(TaskLabel.find_by(task_id: task_with_label.id, label_id: task_with_label.labels[0].id)).to be_nil
      end
    end
  end
end
