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

  describe '検索' do
    describe 'タスク名検索' do
      context 'タスク名が完全一致する場合' do
        let!(:task) { FactoryBot.create(:task, name: 'あいうえお', status: 1) }

        it 'データが取得できる' do
          expect(Task.name_like('あいうえお').status_equal(1).count).to eq 1
        end
      end

      context 'タスク名が部分一致する場合' do
        let!(:task) { FactoryBot.create(:task, name: 'あいうえお') }

        it 'データが取得できる' do
          expect(Task.name_like('いうえ').status_equal(1).count).to eq 1
        end
      end

      context 'タスク名が一致しない場合' do
        let!(:task) { FactoryBot.create(:task, name: 'あいうえお') }

        it 'データが取得できない' do
          expect(Task.name_like('かきくけこ').status_equal(1)).to be_empty
        end
      end

      context 'タスク名が空の場合' do
        let!(:task) { FactoryBot.create(:task, name: 'あいうえお', status: 1) }

        it 'データを取得できない' do
          expect(Task.name_like('').status_equal(1).count).to eq 1
        end
      end

      context 'タスク名がnilの場合' do
        let!(:task) { FactoryBot.create(:task, name: 'あいうえお', status: 1) }

        it 'データを取得できない' do
          expect(Task.name_like(nil).status_equal(1).count).to eq 1
        end
      end
    end

    describe 'ステータス検索' do
      context 'ステータスが一致する場合' do
        let!(:task) { FactoryBot.create(:task, name: 'あいうえお', status: 1) }

        it 'データを取得できる' do
          expect(Task.name_like('あいうえお').status_equal(1).count).to eq 1
        end
      end

      context 'ステータスが一致しない場合' do
        let!(:task) { FactoryBot.create(:task, name: 'あいうえお', status: 2) }

        it 'データを取得できない' do
          expect(Task.name_like('あいうえお').status_equal(1)).to be_empty
        end
      end

      context 'ステータスが空の場合' do
        let!(:task) { FactoryBot.create(:task, name: 'あいうえお', status: 1) }

        it 'データを取得できる' do
          expect(Task.name_like('あいうえお').status_equal('').count).to eq 1
        end
      end

      context 'ステータスがnilの場合' do
        let!(:task) { FactoryBot.create(:task, name: 'あいうえお', status: 1) }

        it 'データを取得できる' do
          expect(Task.name_like('あいうえお').status_equal(nil).count).to eq 1
        end
      end
    end

    describe 'タスク名とステータスの複合' do
      context 'タスク名とステータスが両方一致する場合' do
        let!(:task) { FactoryBot.create(:task, name: 'あいうえお', status: 1) }

        it 'データを取得できる' do
          expect(Task.name_like('あいうえお').status_equal(1).count).to eq 1
        end
      end

      context 'タスク名もステータスも一致しない場合' do
        let!(:task) { FactoryBot.create(:task, name: 'あいうえお', status: 2) }

        it 'データを取得できない' do
          expect(Task.name_like('かきくけこ').status_equal(1)).to be_empty
        end
      end

      context 'タスク名、ステータスが空の場合' do
        let!(:task_1) { FactoryBot.create(:task, name: 'あいうえお', status: 1) }
        let!(:task_2) { FactoryBot.create(:task, name: 'かきくけこ', status: 2) }

        it 'データを全件（２件）取得できる' do
          expect(Task.name_like('').status_equal('').count).to eq 2
        end
      end

      context 'タスク名、ステータスがnilの場合' do
        let!(:task_1) { FactoryBot.create(:task, name: 'あいうえお', status: 1) }
        let!(:task_2) { FactoryBot.create(:task, name: 'かきくけこ', status: 2) }

        it 'データを全件（２件）取得できる' do
          expect(Task.name_like(nil).status_equal(nil).count).to eq 2
        end
      end
    end
  end
end
