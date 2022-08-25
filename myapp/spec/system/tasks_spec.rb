require 'rails_helper'

describe 'Taskモデル', type: :model do
  describe 'バリデーション' do
    describe 'タスク名カラム' do
      context '30文字で入力されている場合' do
        task = FactoryBot.create(:task, title: 'あいうえおあいうえおあいうえおあいうえおあいうえおあいうえお', user_id: '1')
        it '登録できる' do
          expect(task).to be_valid
        end
      end

      context '空の場合' do
        task = FactoryBot.build(:task, title: '', user_id: '1')
        it '無効である' do
          expect(task).to be_invalid
        end
      end

      context 'nilの場合' do
        task = FactoryBot.build(:task, title: nil, user_id: '1')
        it '無効である' do
          expect(task).to be_invalid
        end
      end

      context '31文字以上の場合' do
        task = FactoryBot.build(:task, title: 'あいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあ', user_id: '1')
        it '無効である' do
          expect(task).to be_invalid
        end
      end
    end

    describe '詳細カラム' do
      context '100文字で入力されている場合' do
        it '有効である' do
          task = FactoryBot.create(:task, description: '１いうえおあいうえお２いうえおあいうえお３いうえおあいうえお４いうえお'\
            'あいうえお５いうえおあいうえお６いうえおあいうえお７いうえおあいうえお８いうえおあいうえお９いうえおあいうえお０いうえおあいうえお', user_id: '1')
          expect(task).to be_valid
        end
      end

      context '空の場合' do
        it '無効である' do
          task = FactoryBot.build(:task, description: '', user_id: '1')
          expect(task).to be_invalid
        end
      end

      context 'nilの場合' do
        it '無効である' do
          task = FactoryBot.build(:task, description: nil, user_id: '1')
          expect(task).to be_invalid
        end
      end

      context '101文字以上の場合' do
        it '無効である' do
          task = FactoryBot.build(:task, description: '１いうえおあいうえお２いうえおあいうえお３いうえおあいうえお４いうえおあいうえお５いうえおあいうえお６いうえおあいうえお７いうえおあいうえお８いうえおあいうえお９いうえおあいうえお０いうえおあいうえお１', user_id: '1')
          expect(task).to be_invalid
        end
      end
    end
  end
end
