require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'バリデーションテスト' do
    context 'タスク名、概要、終了期限、ステータスを入力するとき' do
      it 'タスクを登録できる' do
        task = build(:task)

        expect(task).to be_valid
      end
    end

    context '概要が未入力のとき' do
      it 'タスクを登録できる' do
        task = build(:task, content: '')

        expect(task).to be_valid
      end
    end

    context 'タスク名が30文字で入力するとき' do
      it 'タスクを登録できる' do
        task = build(:task, title: 'a' * 30)

        expect(task).to be_valid
      end
    end

    context 'タスク名が未入力のとき' do
      it 'タスクを登録できない' do
        task = build(:task, title: '')

        expect(task).to be_invalid
        expect(task.errors.full_messages).to include('タスク名を入力してください')
      end
    end

    context 'タスク名が31文字以上の入力のとき' do
      it 'タスクを登録できない' do
        task = build(:task, title: 'a' * 31)

        expect(task).to be_invalid
        expect(task.errors.full_messages).to include('タスク名は30文字以内で入力してください')
      end
    end

    context '終了期限が未入力のとき' do
      it 'タスクを登録できない' do
        task = build(:task, deadline: '')

        expect(task).to be_invalid
        expect(task.errors.full_messages).to include('終了期限を入力してください')
      end
    end
  end

  describe 'ソート' do
    let!(:task1) { create(:task, id: '1', title: 'task1', deadline: '2023/04/29', created_at: '2023/04/27 09:00') }
    let!(:task2) { create(:task, id: '2', title: 'task2', deadline: '2023/04/28', created_at: '2023/04/29 09:00') }
    let!(:task3) { create(:task, id: '3', title: 'task3', deadline: '2023/04/27', created_at: '2023/04/28 09:00') }

    context '終了期限ソートが昇順のとき' do
      it '終了期限の古い日付順に表示' do
        expect(Task.deadline_order('asc')).to eq [task3, task2, task1]
      end
    end

    context '終了期限ソートが降順のとき' do
      it '終了期限の新しい日付順に表示' do
        expect(Task.deadline_order('desc')).to eq [task1, task2, task3]
      end
    end

    context '終了期限ソートが不正値のとき' do
      it '作成日の新しい日付順に表示' do
        expect(Task.deadline_order('a')).to eq [task2, task3, task1]
      end
    end
  end

  describe '検索' do
    describe 'タスク名検索' do
      context 'タスク名が完全一致するとき' do
        let!(:task) { create(:task, title: 'あいうえお') }

        it 'データが取得できる' do
          expect(Task.where_title('あいうえお').count).to eq 1
        end
      end

      context 'タスク名が部分一致するとき' do
        let!(:task) { create(:task, title: 'あいうえお') }

        it 'データが取得できる' do
          expect(Task.where_title('いうえ').count).to eq 1
        end
      end

      context 'タスク名が一致しないとき' do
        let!(:task) { create(:task, title: 'あいうえお') }

        it 'データが取得できない' do
          expect(Task.where_title('かきくけこ')).to be_empty
        end
      end

      context 'タスク名が空のとき' do
        let!(:task) { create(:task, title: 'あいうえお') }

        it 'データを取得できない' do
          expect(Task.where_title('').count).to eq 1
        end
      end

      context 'タスク名がnilのとき' do
        let!(:task) { create(:task, title: 'あいうえお') }

        it 'データを取得できない' do
          expect(Task.where_title(nil).count).to eq 1
        end
      end
    end

    describe 'ステータス検索' do
      context 'ステータスが一致するとき' do
        let!(:task) { create(:task, title: 'あいうえお') }

        it 'データを取得できる' do
          expect(Task.where_title('あいうえお').count).to eq 1
        end
      end

      context 'ステータスが一致しないとき' do
        let!(:task) { create(:task, status: 2) }

        it 'データを取得できない' do
          expect(Task.where_status(1)).to be_empty
        end
      end

      context 'ステータスが空のとき' do
        let!(:task) { create(:task, status: 1) }

        it 'データを取得できる' do
          expect(Task.where_status('').count).to eq 1
        end
      end

      context 'ステータスがnilのとき' do
        let!(:task) { create(:task, status: 1) }

        it 'データを取得できる' do
          expect(Task.where_status(nil).count).to eq 1
        end
      end
    end

    describe 'ラベル検索' do
      context 'ラベルが一致するとき' do
        let!(:task) { create(:task, title: 'あいうえお') }

        it 'データを取得できる' do
          expect(Task.where_title('あいうえお').count).to eq 1
        end
      end

      context 'ラベルが一致しないとき' do
        let!(:task) { create(:task, status: 2) }

        it 'データを取得できない' do
          expect(Task.where_status(1)).to be_empty
        end
      end

      context 'ラベルが空のとき' do
        let!(:task) { create(:task, label_id: 1) }

        it 'データを取得できる' do
          expect(Label.where_label('').count).to eq 1
        end
      end

      context 'ラベルがnilのとき' do
        let!(:task) { create(:task, status: 1) }

        it 'データを取得できる' do
          expect(Task.where_status(nil).count).to eq 1
        end
      end
    end

    describe 'タスク名とステータスの複合' do
      context 'タスク名とステータスが両方一致するとき' do
        let!(:task) { create(:task, title: 'あいうえお', status: 1) }

        it 'データを取得できる' do
          expect(Task.where_title('あいうえお').where_status(1).count).to eq 1
        end
      end

      context 'タスク名もステータスも一致しないとき' do
        let!(:task) { create(:task, title: 'あいうえお', status: 2) }

        it 'データを取得できない' do
          expect(Task.where_title('かきくけこ').where_status(1)).to be_empty
        end
      end

      context 'タスク名、ステータスが空のとき' do
        let!(:task1) { create(:task, title: 'あいうえお', status: 1) }
        let!(:task2) { create(:task, title: 'かきくけこ', status: 2) }

        it 'データを全件（２件）取得できる' do
          expect(Task.where_title('').where_status('').count).to eq 2
        end
      end

      context 'タスク名、ステータスがnilのとき' do
        let!(:task_1) { create(:task, title: 'あいうえお', status: 1) }
        let!(:task_2) { create(:task, title: 'かきくけこ', status: 2) }

        it 'データを全件（２件）取得できる' do
          expect(Task.where_title(nil).where_status(nil).count).to eq 2
        end
      end
    end
  end
end
