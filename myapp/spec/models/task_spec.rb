require 'rails_helper'

describe 'Taskモデル', type: :model do
  describe 'バリデーション' do
    describe 'タスク名カラム' do
      context '30文字で入力されている場合' do
        let!(:task) { FactoryBot.create(:task, name: 'あいうえお') }

        it '登録できる' do
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
        it '無効である' do
          task = FactoryBot.build(:task, detail: '１いうえおあいうえお２いうえおあいうえお３いうえおあいうえお４いうえおあいうえお５いうえおあいうえお６いうえおあいうえお７いうえおあいうえお８いうえおあいうえお９いうえおあいうえお０いうえおあいうえお１')
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
    end

    describe '優先度カラム' do
      context '入力されている場合' do
        let!(:task) { FactoryBot.build(:task) }
        it '有効である' do
          expect(task).to be_valid
        end
      end

      context 'nilの場合' do
        let!(:task) { FactoryBot.create(:task, priority: nil) }
        it '有効である' do
          expect(task).to be_valid
        end
      end
    end
  end

  describe '検索' do
    context 'タスク名が完全一致するデータが存在する場合' do
      let!(:task) { FactoryBot.create(:task, name: 'あいうえお', status: 1) }

      it 'タスク名が一致するデータが取得できる' do
        expect(Task.search('あいうえお', 1).count).to eq 1
      end
    end

    context 'タスク名が前方一致するデータが存在する場合' do
      let!(:task) { FactoryBot.create(:task, name: '検索テスト') }

      it 'タスク名が一致するデータが取得できる' do
        expect(Task.search('検索', 1).count).to eq 1
      end
    end

    context 'タスク名が後方一致するデータが存在する場合' do
      let!(:task) { FactoryBot.create(:task, name: '検索テスト') }

      it 'タスク名が一致するデータが取得できる' do
        Task.all.each do |t|
          puts t.name
        end
        expect(Task.search('テスト', 1).count).to eq 1
      end
    end

    context 'タスク名が真ん中で一致するデータが存在する場合' do
      let!(:task) { FactoryBot.create(:task, name: 'あいうえお') }

      it 'タスク名が一致するデータが取得できる' do
        expect(Task.search('いうえ', 1).count).to eq 1
      end
    end

    context 'タスク名が一致するデータが存在しない場合' do
      let!(:task) { FactoryBot.create(:task, name: 'あいうえお') }

      it 'データが取得できない' do
        expect(Task.search('かきくけこ', 1)).to be_empty
      end
    end

    context 'ステータスが一致するデータが存在する場合' do
      let!(:task) { FactoryBot.create(:task, status: 1) }

      it 'ステータスが一致するデータが取得できる' do
        expect(Task.search(1).count).to eq 1
      end
    end

    # context 'ステータスが一致するデータが存在しない場合' do
    #   it 'データを取得できない' do

    #   end
    # end

    # context 'タスク名、ステータス両方が一致するデータが存在する場合' do
    #   it 'データを取得できる' do

    #   end
    # end

    # context 'タスク名が一致し、ステータスが一致しないデータが存在する場合' do
    #   it 'データを取得できない' do

    #   end
    # end

    # context 'タスク名が一致せずステータスが一致するデータが存在する場合' do
    #   it 'データを取得できない' do

    #   end
    # end

    # context 'タスク名もステータスも一致するデータが存在しない場合' do
    #   it 'データを取得できない' do

    #   end
    # end

    # context 'タスク名が空の場合' do
    #   it 'データを取得できない' do

    #   end
    # end

    # context 'ステータスが空の場合' do
    #   it 'データを取得できない' do

    #   end
    # end

    # context 'タスク名、ステータスが空の場合' do
    #   it 'データが全件取得される' do

    #   end
    # end
  end
end
