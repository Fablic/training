require 'rails_helper'

describe 'Taskモデル', type: :model do
  describe 'バリデーション' do
    describe 'タスク名カラム' do
      context '30文字で入力されている場合' do
        task = FactoryBot.create(:task, name: 'あいうえおあいうえおあいうえおあいうえおあいうえおあいうえお')
        it '登録できる' do
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

      context '31文字以上の場合' do
        task = FactoryBot.build(:task, name: 'あいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあ')
        it '無効である' do
          expect(task).to be_invalid
        end
      end
    end

    describe '詳細カラム' do
      context '100文字で入力されている場合' do
        it '有効である' do
          task = FactoryBot.create(:task, detail: '１いうえおあいうえお２いうえおあいうえお３いうえおあいうえお４いうえお'\
            'あいうえお５いうえおあいうえお６いうえおあいうえお７いうえおあいうえお８いうえおあいうえお９いうえおあいうえお０いうえおあいうえお')
          expect(task).to be_valid
        end
      end

      context '空の場合' do
        it '無効である' do
          task = FactoryBot.build(:task, detail: '')
          expect(task).to be_invalid
        end
      end

      context 'nilの場合' do
        it '無効である' do
          task = FactoryBot.build(:task, detail: nil)
          expect(task).to be_invalid
        end
      end

      context '101文字以上の場合' do
        it '無効である' do
          task = FactoryBot.build(:task, detail: '１いうえおあいうえお２いうえおあいうえお３いうえおあいうえお４いうえおあいうえお５いうえおあいうえお６いうえおあいうえお７いうえおあいうえお８いうえおあいうえお９いうえおあいうえお０いうえおあいうえお１')
          expect(task).to be_invalid
        end
      end
    end

    describe 'ステータスカラム' do
      context '入力されている場合' do
        it '有効である' do
          task = FactoryBot.create(:task)
          expect(task).to be_valid
        end
      end

      context 'nilの場合' do
        it '有効である' do
          task = FactoryBot.create(:task, status: nil)
          expect(task).to be_valid
        end
      end
    end

    describe '優先度カラム' do
      context '入力されている場合' do
        task = FactoryBot.create(:task)
        it '有効である' do
          expect(task).to be_valid
        end
      end

      context 'nilの場合' do
        task = FactoryBot.create(:task, priority: nil)
        it '有効である' do
          expect(task).to be_valid
        end
      end
    end
  end
end
