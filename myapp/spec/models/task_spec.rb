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

  describe '検索' do
    describe 'タスク名検索' do
      context 'タスク名が完全一致する場合' do
        let!(:task) { FactoryBot.create(:task, name: 'あいうえお', status: 1) }

        it 'データが取得できる' do
          expect(Task.search('あいうえお', 1).count).to eq 1
        end
      end

      context 'タスク名が前方一致する場合' do
        let!(:task) { FactoryBot.create(:task, name: 'あいうえお') }

        it 'データが取得できる' do
          expect(Task.search('あいう', 1).count).to eq 1
        end
      end

      context 'タスク名が後方一致する場合' do
        let!(:task) { FactoryBot.create(:task, name: 'あいうえお') }

        it 'データが取得できる' do
          expect(Task.search('うえお', 1).count).to eq 1
        end
      end

      context 'タスク名が中央一致する場合' do
        let!(:task) { FactoryBot.create(:task, name: 'あいうえお') }

        it 'データが取得できる' do
          expect(Task.search('いうえ', 1).count).to eq 1
        end
      end

      context 'タスク名が一致しない場合' do
        let!(:task) { FactoryBot.create(:task, name: 'あいうえお') }

        it 'データが取得できない' do
          expect(Task.search('かきくけこ', 1)).to be_empty
        end
      end

      context 'タスク名が空の場合' do
        let!(:task) { FactoryBot.create(:task, name: 'あいうえお', status: 1) }

        it 'データを取得できない' do
          expect(Task.search('', 1).count).to eq 1
        end
      end

      context 'タスク名がnilの場合' do
        let!(:task) { FactoryBot.create(:task, name: 'あいうえお', status: 1) }

        it 'データを取得できない' do
          expect(Task.search(nil, 1).count).to eq 1
        end
      end
    end

    describe 'ステータス検索' do
      context 'ステータスが一致する場合' do
        let!(:task) { FactoryBot.create(:task, name: 'あいうえお', status: 1) }

        it 'データを取得できる' do
          expect(Task.search('あいうえお', 1).count).to eq 1
        end
      end

      context 'ステータスが一致しない場合' do
        let!(:task) { FactoryBot.create(:task, name: 'あいうえお', status: 2) }

        it 'データを取得できない' do
          expect(Task.search('あいうえお', 1)).to be_empty
        end
      end

      context 'ステータスが空の場合' do
        let!(:task) { FactoryBot.create(:task, name: 'あいうえお', status: 1) }

        it 'データを取得できる' do
          expect(Task.search('あいうえお', '').count).to eq 1
        end
      end

      context 'ステータスがnilの場合' do
        let!(:task) { FactoryBot.create(:task, name: 'あいうえお', status: 1) }

        it 'データを取得できる' do
          expect(Task.search('あいうえお', nil).count).to eq 1
        end
      end
    end

    describe 'タスク名とステータスの複合' do
      context 'タスク名とステータスが両方一致する場合' do
        let!(:task) { FactoryBot.create(:task, name: 'あいうえお', status: 1) }

        it 'データを取得できる' do
          expect(Task.search('あいうえお', 1).count).to eq 1
        end
      end

      context 'タスク名もステータスも一致しない場合' do
        let!(:task) { FactoryBot.create(:task, name: 'あいうえお', status: 2) }

        it 'データを取得できない' do
          expect(Task.search('かきくけこ', 1)).to be_empty
        end
      end

      context 'タスク名、ステータスが空の場合' do
        let!(:task_1) { FactoryBot.create(:task, name: 'あいうえお', status: 1) }
        let!(:task_2) { FactoryBot.create(:task, name: 'かきくけこ', status: 2) }

        it 'データを全件（２件）取得できる' do
          expect(Task.search('', '').count).to eq 2
        end
      end

      context 'タスク名、ステータスがnilの場合' do
        let!(:task_1) { FactoryBot.create(:task, name: 'あいうえお', status: 1) }
        let!(:task_2) { FactoryBot.create(:task, name: 'かきくけこ', status: 2) }

        it 'データを全件（２件）取得できる' do
          expect(Task.search(nil, nil).count).to eq 2
        end
      end
    end
  end
end
