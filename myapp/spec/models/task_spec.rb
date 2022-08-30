require 'rails_helper'

describe 'Taskモデル', type: :model do
  describe 'バリデーション' do
    describe 'タスク名カラム' do
      context '30文字で入力されている場合' do
        let!(:task) { FactoryBot.build(:task, name: 'あいうえおあいうえおあいうえおあいうえおあいうえおあいうえお') }

        it '有効である' do
          expect(task).to be_valid
        end
      end

      context '空の場合' do
        let!(:task) { FactoryBot.build(:task, name: '') }

        it '無効である' do
          expect(task).to be_invalid
        end
      end

      context 'nilの場合' do
        let!(:task) { FactoryBot.build(:task, name: nil) }

        it '無効である' do
          expect(task).to be_invalid
        end
      end

      context '31文字以上の場合' do
        let!(:task) { FactoryBot.build(:task, name: 'あいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあ') }

        it '無効である' do
          expect(task).to be_invalid
        end
      end
    end

    describe '詳細カラム' do
      context '100文字で入力されている場合' do
        let!(:task) { FactoryBot.build(:task, detail: '１いうえおあいうえお２いうえおあいうえお３いうえおあいうえお４いうえお'\
          'あいうえお５いうえおあいうえお６いうえおあいうえお７いうえおあいうえお８いうえおあいうえお９いうえおあいうえお０いうえおあいうえお') }

        it '有効である' do
          expect(task).to be_valid
        end
      end

      context '空の場合' do
        let!(:task) { FactoryBot.build(:task, detail: '') }

        it '無効である' do
          expect(task).to be_invalid
        end
      end

      context 'nilの場合' do
        let!(:task) { FactoryBot.build(:task, detail: nil) }

        it '無効である' do
          expect(task).to be_invalid
        end
      end

      context '101文字以上の場合' do
        let!(:task) { FactoryBot.build(:task, detail: '１いうえおあいうえお２いうえおあいうえお３いうえおあいうえお４いうえお'\
          'あいうえお５いうえおあいうえお６いうえおあいうえお７いうえおあいうえお８いうえおあいうえお９いうえおあいうえお０いうえおあいうえお１')}

        it '無効である' do
          expect(task).to be_invalid
        end
      end
    end

    describe 'ステータスカラム' do
      context '入力されている場合' do
        let!(:task) { FactoryBot.build(:task) }

        it '有効である' do
          expect(task).to be_valid
        end
      end

      context 'nilの場合' do
        let!(:task) { FactoryBot.build(:task, status: nil) }

        it '有効である' do
          expect(task).to be_valid
        end
      end

      context 'enumで設定されていない値の場合' do
        it '引数エラーの例外を投げる' do
          expect{ FactoryBot.build(:task, status: 4) }.to raise_error(ArgumentError)
        end
      end
    end

    describe '優先度カラム' do
      context '入力されている場合' do
        let!(:task) { FactoryBot.build(:task) }

        it '有効である' do
          expect(task).to be_valid
        end
      end

      context 'nilの場合' do
        let!(:task) { FactoryBot.build(:task, priority: nil) }

        it '有効である' do
          expect(task).to be_valid
        end
      end

      context 'enumで設定されていない値の場合' do
        it '引数エラーの例外を投げる' do
          expect{ FactoryBot.build(:task, priority: 4) }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
