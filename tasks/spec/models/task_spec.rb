require 'rails_helper'

RSpec.describe Task, type: :model do
  describe '正常系' do
    context 'タスク名、ステータス、優先度がある場合' do
      let(:task) { build(:task) }
      it '有効である' do
        expect(task).to be_valid
      end
    end
  end

  describe 'タスク名バリデーション' do
    let(:task) { build(:task, task_name: task_name) }
    context 'タスク名がない場合' do
      let(:task_name) { '' }
      it 'エラーになる' do
        expect(task).to be_invalid
        expect(task.errors[:task_name]).to include('を入力してください')
      end
    end
    context 'タスク名の文字数が上限未満の場合' do
      let(:task_name) { 'a' * 59 }
      it '有効である' do
        expect(task).to be_valid
      end
    end
    context 'タスク名の文字数が上限と同じ場合' do
      let(:task_name) { 'a' * 60 }
      it '有効である' do
        expect(task).to be_valid
      end
    end
    context 'タスク名の文字数が上限を超える場合' do
      let(:task_name) { 'a' * 61 }
      it 'エラーになる' do
        expect(task).to be_invalid
        expect(task.errors[:task_name]).to include('は60文字以内で入力してください')
      end
    end
  end

  describe 'ステータスのバリデーション' do
    let(:task) { build(:task, status_id: status) }
    context 'ステータスがない場合' do
      let(:status) { nil }
      it 'エラーになる' do
        task.status_id = status
        expect(task).to be_invalid
        expect(task.errors[:status]).to include('を入力してください')
      end
    end
  end

  describe '優先度のバリデーション' do
    let(:task) { build(:task, priority_id: priority) }
    context '優先度がない場合' do
      let(:priority) { nil }
      it 'エラーになる' do
        expect(task).to be_invalid
        expect(task.errors[:priority]).to include('を入力してください')
      end
    end
  end

  describe 'ラベルのバリデーション' do
    let(:task) { build(:task, label: label) }
    context '空文字の場合' do
      let(:label) { '' }
      it '有効である' do
        expect(task).to be_valid
      end
    end
    context '文字数が上限未満の場合' do
      let(:label) { 'a' * 19 }
      it '有効である' do
        expect(task).to be_valid
      end
    end
    context '文字数が上限と同じ場合' do
      let(:label) { 'a' * 20 }
      it '有効である' do
        expect(task).to be_valid
      end
    end
    context '文字数が上限を超える場合' do
      let(:label) { 'a' * 21 }
      it 'エラーになる' do
        expect(task).to be_invalid
        expect(task.errors[:label]).to include('は20文字以内で入力してください')
      end
    end
  end

  describe '詳細説明のバリデーション' do
    let(:task) { build(:task, detail: detail) }
    context '空文字の場合' do
      let(:detail) { '' }
      it '有効である' do
        expect(task).to be_valid
      end
    end
    context '文字数が上限未満の場合' do
      let(:detail) { 'a' * 249 }
      it '有効である' do
        expect(task).to be_valid
      end
    end
    context '文字数が上限と同じ場合' do
      let(:detail) { 'a' * 250 }
      it '有効である' do
        expect(task).to be_valid
      end
    end
    context '詳細説明の文字数が上限を超える場合' do
      let(:detail) { 'a' * 251 }
      it 'エラーになる' do
        expect(task).to be_invalid
        expect(task.errors[:detail]).to include('は250文字以内で入力してください')
      end
    end
  end

  describe '期限のバリデーション' do
    let(:task) { build(:task, limit_date: limit_date) }
    context '期限を設定していない場合' do
      let(:limit_date) { nil }
      it '有効である' do
        expect(task).to be_valid
      end
    end
    context '期限が現在時刻より後に設定する場合' do
      let(:limit_date) { Time.current + 1.minute }
      it '有効である' do
        expect(task).to be_valid
      end
    end
    context '現在時刻と同じに設定する場合' do
      let(:limit_date) { Time.current }
      it 'エラーになる' do
        expect(task).to be_invalid
        expect(task.errors[:limit_date]).to include('現在時刻より前の日時は設定できません')
      end
    end
    context '現在時刻より前に設定する場合' do
      let(:limit_date) { Time.current - 1.minute }
      it 'エラーになる' do
        expect(task).to be_invalid
        expect(task.errors[:limit_date]).to include('現在時刻より前の日時は設定できません')
      end
    end
  end

  describe 'すでに設定されている期限が現在時刻より前の日時のバリデーション' do
    let(:task) { travel(-1.day) { create(:exist_limit_date_task) } }
    context '期限が変更されていない場合' do
      it '有効である' do
        expect(task).to be_valid
      end
    end
    context '現在時刻より前の日時に期限が変更される場合' do
      it 'エラーになる' do
        task.limit_date = Time.current - 1.minute
        expect(task).to be_invalid
        expect(task.errors[:limit_date]).to include('現在時刻より前の日時は設定できません')
      end
    end
    context '現在時刻より後の日時に期限が変更される場合' do
      it '有効である' do
        task.limit_date = Time.current + 1.minute
        expect(task).to be_valid
      end
    end
  end

  describe '検索・絞り込み・ソート機能' do
    let!(:task_list) do
      [
        create(:task_list_item),
        create(:task_list_item, task_name: 'テスト1', status: create(:started), created_at: Time.current + 1.day, limit_date: Time.current + 5.days),
        create(:task_list_item, task_name: 'タスク1', status: create(:finished), created_at: Time.current + 2.days, limit_date: Time.current + 3.days),
        create(:task_list_item, task_name: 'テスト2', status: create(:notStarted), created_at: Time.current + 3.days, limit_date: Time.current + 6.days),
        create(:task_list_item, task_name: 'タスク2', status: create(:started), created_at: Time.current + 4.days, limit_date: Time.current + 4.days),
        create(:task_list_item, task_name: 'テストタスク1', deleted_at: Time.current, limit_date: Time.current + 2.days)
      ]
    end
    context '検索文字が空欄で、絞り込みの指定がなく、ソートを行っていない場合' do
      it '論理削除されていない、タスクを全て、作成日時の降順で取得する' do
        expect(Task.search(nil, nil, 'created_at desc')).to match [task_list[4], task_list[3], task_list[2], task_list[1], task_list[0]]
      end
    end
    context '検索文字が「タス」で、絞り込みの指定がなく、ソートを行っていない場合' do
      it '論理削除されていない、タスク名に「タス」を含むタスクを全て、作成日時の降順で取得する' do
        expect(Task.search('タス', nil, 'created_at desc')).to match [task_list[4], task_list[2], task_list[0]]
      end
    end
    context '検索文字が空欄で、絞り込みが「着手」を指定、ソートを行っていない場合' do
      it '論理削除されていない、ステータスが「着手」のタスクを全て、作成日時の降順で取得する' do
        expect(Task.search(nil, ['2'], 'created_at desc')).to match [task_list[4], task_list[1]]
      end
    end
    context '検索文字が空欄で、絞り込みが「着手」と「完了」を指定、ソートを行っていない場合' do
      it '論理削除されていない、ステータスが「着手」と「完了」のタスクを全て、作成日時の降順で取得する' do
        expect(Task.search(nil, %w[2 3], 'created_at desc')).to match [task_list[4], task_list[2], task_list[1]]
      end
    end
    context '検索文字が空欄で、絞り込みが「未着手」と「着手」と「完了」の全てを指定、ソートを行っていない場合' do
      it '論理削除されていない、タスクを全て、作成日時の降順で取得する' do
        expect(Task.search(nil, %w[1 2 3], 'created_at desc')).to match [task_list[4], task_list[3], task_list[2], task_list[1], task_list[0]]
      end
    end
    context '検索文字が空欄で、絞り込みの指定がなく、期限の昇順でソートを行っていた場合' do
      it '論理削除されていない、タスクを全て、期限の昇順で取得する' do
        expect(Task.search(nil, nil, 'limit_date asc')).to match [task_list[0], task_list[2], task_list[4], task_list[1], task_list[3]]
      end
    end
    context '検索文字が「テス」で、絞り込みの「未着手」を指定、期限の降順でソートを行っていた場合' do
      it '論理削除されていない、タスク名に「テス」を含み、ステータスが「未着手」のタスクを全て、期限の降順で取得する' do
        expect(Task.search('テス', ['1'], 'limit_date desc')).to match [task_list[3], task_list[0]]
      end
    end
  end
end
