require 'rails_helper'

RSpec.describe Task, type: :model do
  let!(:user) do
    FactoryBot.create(:user)
  end
  example '作成できるか' do
    task = FactoryBot.build(:task, user_id: user.id)
    expect(task).to be_valid
  end

  example 'タイトルが存在しないと無効' do
    task_notitle = FactoryBot.build(:task, :no_title, user_id: user.id)
    task_notitle.valid?
    expect(task_notitle.errors[:title]).to include I18n.t('errors.messages.blank')
  end

  example 'タイトルが256文字以上だと無効' do
    task_longtitle = FactoryBot.build(:task, :long_title, user_id: user.id)
    task_longtitle.valid?
    expect(task_longtitle.errors[:title]).to include I18n.t('errors.messages.too_long', count: 255)
  end

  describe '#search' do
    let!(:task_hoge) do
      FactoryBot.create(:task, title: 'hogehoge', user_id: user.id)
    end
    let!(:task_fuga) do
      FactoryBot.create(:task, title: 'fugafuga', user_id: user.id)
    end
    let!(:task_complete) do
      FactoryBot.create(:task, :status_completed, user_id: user.id)
    end
    let!(:task_with_label) do
      FactoryBot.create(:task, :with_label, user_id: user.id)
    end

    context '何も指定しないとき' do
      example 'キーワード、ステータス、ラベルを指定しない時は全て返す' do
        search_noword = Task.search_title('').search_status('').search_label('')
        expect(search_noword.length).to eq 4
      end
    end

    context 'タイトルで検索したとき' do
      example 'タイトルが部分一致する配列を返す' do
        search_title = Task.search_title('hoge')
        expect(search_title).to include(task_hoge)
        expect(search_title.length).to eq 1
      end
    end

    context 'ステータスで検索したとき' do
      example 'ステータスが一致する配列を返す' do
        search_complete = Task.search_status('2')
        expect(search_complete).to include(task_complete)
        expect(search_complete.length).to eq 1
      end
    end

    context 'ラベルで検索したとき' do
      example 'ラベルが一致する配列を返す' do
        search_label = Task.search_label('sample-label')
        expect(search_label).to include(task_with_label)
        expect(search_label.length).to eq 1
      end
    end
  end

  describe 'リレーション' do
    context 'ラベルが存在するとき' do
      example 'タスクを削除した時にタスクとラベルの中間テーブルも削除される' do
        task_label = FactoryBot.create(:task, :with_label, user_id: user.id)
        Task.destroy(task_label.id)
        expect(TaskLabel.find_by(task_id: task_label.id)).to be_nil
      end
    end
  end
end
