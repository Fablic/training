require 'rails_helper'

RSpec.describe 'Task', type: :model do
  describe 'バリデーションのテスト' do
    context '件名、詳細が空ではない' do
      it 'バリデーションエラーにならないこと' do
        task = build(:task)
        expect(task).to be_valid
      end
    end
    context '件名が空' do
      it 'バリデーションエラーになること' do
        task = build(:task, title: nil)
        expect(task.valid?).to eq false
        expect(task.errors.full_messages).to include('件名を入力してください')
      end
    end
    context '詳細が空' do
      it 'バリデーションエラーになること' do
        task = build(:task, content: nil)
        expect(task.valid?).to eq false
        expect(task.errors.full_messages).to include('詳細を入力してください')
      end
    end
  end
end
