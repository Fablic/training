require 'rails_helper'

describe 'Taskモデル', type: :model do
  describe 'バリデーション' do
    describe 'タスク名' do
      context '10文字で入力されている場合' do
        task = FactoryBot.build(:task, name: 'あいうえおあいうえお')
        it '有効である' do
          expect(task).to be_valid
        end
      end

      context '空の場合' do
        task = FactoryBot.build(:task, name: '')
        it '無効である' do
          expect(task).to be_invalid
        end
      end

      context 'nilの場合' do
        task = FactoryBot.build(:task, name: nil)
        it '無効である' do
          expect(task).to be_invalid
        end
      end

      context '11文字以上の場合' do
        task = FactoryBot.build(:task, name: 'あいうえおあいうえおあ')
        it '無効である' do
          expect(task).to be_invalid
        end
      end
    end

    describe '詳細' do
      context '50文字で入力されている場合' do
        it '有効である' do
          task = FactoryBot.build(:task, description: 'あいうえおあいうえおあいうえおあいうえおあいうえお'\
            'あいうえおあいうえおあいうえおあいうえおあいうえお')
          expect(task).to be_valid
        end
      end

      context '空の場合' do
        it '無効である' do
          task = FactoryBot.build(:task, description: '')
          expect(task).to be_invalid
        end
      end

      context 'nilの場合' do
        it '無効である' do
          task = FactoryBot.build(:task, description: nil)
          expect(task).to be_invalid
        end
      end

      context '51文字以上の場合' do
        it '無効である' do
          task = FactoryBot.build(:task, description: 'あいうえおあいうえおあいうえおあいうえおあいうえお'\
            'あいうえおあいうえおあいうえおあいうえおあいうえおあ')
          expect(task).to be_invalid
        end
      end
    end
  end
end
