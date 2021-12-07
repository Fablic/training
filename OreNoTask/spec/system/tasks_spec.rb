# frozen_string_literal: true

require 'rails_helper'
describe 'タスク管理機能', type: :system do
  let(:rspec_session) { { user_id: user_taro.id } }
  let!(:user_taro) { create(:user, name: 'TaroRakuten', password: 'rakuten') }
  let(:user_hanako) { create(:user, name: 'HanakoRakuten', password: 'rakuten') }
  let!(:hanako_task) { create(:task, name: '花子のタスク', status: :not_started, start_at: '2021/12/02 10:00', due_date_at: '2021/12/03 11:00', user_id: user_hanako.id) } # rubocop:disable Layout/LineLength

  before do
    create(:task, name: '最初のタスク', description: '説明文', status: :not_started, start_at: '2021/09/01 10:00', due_date_at: '2021/09/02 11:00', created_at: '2021/07/01 09:00:04', user_id: user_taro.id) # rubocop:disable Layout/LineLength
    create(:task, name: '２番目のタスク', description: '説明文２', status: :completed, start_at: '2021/08/02 10:00', due_date_at: '2021/08/03 11:00', created_at: '2021/07/01 09:00:03', user_id: user_taro.id) # rubocop:disable Layout/LineLength
    create(:task, name: '追加したタスク', description: '追加した説明文', status: :wip, start_at: '2021/10/01 10:00', due_date_at: '2021/10/03 11:00', created_at: '2021/07/01 09:00:02', user_id: user_taro.id) # rubocop:disable Layout/LineLength
    create(:task, name: '最後のタスク', status: :not_started, start_at: '2021/12/02 10:00', due_date_at: '2021/12/03 11:00', created_at: '2021/07/01 09:00:01', user_id: user_taro.id) # rubocop:disable Layout/LineLength
  end

  describe 'タスク一覧' do
    before do
      visit tasks_path
    end

    context 'デフォルト表示' do
      it '一覧のデフォルト表示が期待通り' do
        expect(find('.task-list > li:nth-child(1)')).to have_content '最初のタスク'
        expect(find('.task-list > li:nth-child(1)')).to have_content '2021年09月01日(水) 10:00 〜 2021年09月02日(木) 11:00'
        expect(find('.task-list > li:nth-child(2)')).to have_content '２番目のタスク'
        expect(find('.task-list > li:nth-child(2)')).to have_content '2021年08月02日(月) 10:00 〜 2021年08月03日(火) 11:00'
        expect(find('.task-list > li:nth-child(3)')).to have_content '追加したタスク'
        expect(find('.task-list > li:nth-child(3)')).to have_content '2021年10月01日(金) 10:00 〜 2021年10月03日(日) 11:00'
        expect(find('.task-list > li:nth-child(4)')).to have_content '最後のタスク'
        expect(find('.task-list > li:nth-child(4)')).to have_content '2021年12月02日(木) 10:00 〜 2021年12月03日(金) 11:00'
        expect(page).not_to have_content '花子のタスク'
      end
    end

    describe '並び替えリンク' do
      context '各リンクをクリックする' do
        it '正しく降順に並ぶ' do
          click_link '降順'
          expect(find('.task-list > li:nth-child(1)')).to have_content '最後のタスク'
          expect(find('.task-list > li:nth-child(2)')).to have_content '追加したタスク'
          expect(find('.task-list > li:nth-child(3)')).to have_content '最初のタスク'
          expect(find('.task-list > li:nth-child(4)')).to have_content '２番目のタスク'
        end

        it '正しく昇順に並ぶ' do
          click_link '昇順'
          expect(find('.task-list > li:nth-child(1)')).to have_content '２番目のタスク'
          expect(find('.task-list > li:nth-child(2)')).to have_content '最初のタスク'
          expect(find('.task-list > li:nth-child(3)')).to have_content '追加したタスク'
          expect(find('.task-list > li:nth-child(4)')).to have_content '最後のタスク'
        end

        it '並び替えがリセットされる' do
          click_link 'クリア'
          expect(find('.task-list > li:nth-child(1)')).to have_content '最初のタスク'
          expect(find('.task-list > li:nth-child(2)')).to have_content '２番目のタスク'
          expect(find('.task-list > li:nth-child(3)')).to have_content '追加したタスク'
          expect(find('.task-list > li:nth-child(4)')).to have_content '最後のタスク'
        end
      end
    end

    describe '検索機能' do
      context 'ステータス指定なしでタスク名を検索する' do
        it '検索対象の名前のタスクのみ表示される' do
          fill_in 'keyword', with: '追加したタスク'
          click_button 'commit'

          expect(page).to have_content '追加したタスク'
          expect(page).not_to have_content '最初のタスク'
          expect(page).not_to have_content '２番目のタスク'
          expect(page).not_to have_content '最後のタスク'
        end
      end

      context 'ステータス指定なしでタスク内容を検索する' do
        it '検索対象の内容のタスクのみ表示される' do
          fill_in 'keyword', with: '説明文２'
          click_button 'commit'

          expect(page).to have_content '２番目のタスク'
          expect(page).not_to have_content '最初のタスク'
          expect(page).not_to have_content '追加したタスク'
          expect(page).not_to have_content '最後のタスク'
        end
      end

      context '正しい組み合わせでステータス指定ありでタスク名を検索する' do
        it '検索対象の名前のタスクのみ表示される' do
          fill_in 'keyword', with: '２番目のタスク'
          select '完了', from: 'status'
          click_button 'commit'

          expect(page).to have_content '２番目のタスク'
          expect(page).not_to have_content '最初のタスク'
          expect(page).not_to have_content '追加したタスク'
          expect(page).not_to have_content '最後のタスク'
        end
      end

      context '間違った組み合わせでステータス指定ありでタスク名を検索する' do
        it '何も表示されない' do
          fill_in 'keyword', with: '２番目のタスク'
          select '作業中', from: 'status'
          click_button 'commit'

          expect(page).not_to have_content '２番目のタスク'
          expect(page).not_to have_content '最初のタスク'
          expect(page).not_to have_content '追加したタスク'
          expect(page).not_to have_content '最後のタスク'
        end
      end

      context '正しい組み合わせでステータス指定ありでタスク内容を検索する' do
        it '検索対象の名前のタスクのみ表示される' do
          fill_in 'keyword', with: '追加した説明文'
          select '作業中', from: 'status'
          click_button 'commit'

          expect(page).to have_content '追加したタスク'
          expect(page).not_to have_content '最初のタスク'
          expect(page).not_to have_content '２番目のタスク'
          expect(page).not_to have_content '最後のタスク'
        end
      end

      context '間違った組み合わせでステータス指定ありでタスク内容を検索する' do
        it '何も表示されない' do
          fill_in 'keyword', with: '追加した説明文'
          select '完了', from: 'status'
          click_button 'commit'

          expect(page).not_to have_content '２番目のタスク'
          expect(page).not_to have_content '最初のタスク'
          expect(page).not_to have_content '追加したタスク'
          expect(page).not_to have_content '最後のタスク'
        end
      end

      context '文字列入力せずステータスのみで検索する' do
        it '未着手のみが表示される' do
          select '未着手', from: 'status'
          click_button 'commit'

          expect(page).not_to have_content '追加したタスク'
          expect(page).to have_content '最初のタスク'
          expect(page).not_to have_content '２番目のタスク'
          expect(page).to have_content '最後のタスク'
        end

        it '作業中のみが表示される' do
          select '作業中', from: 'status'
          click_button 'commit'

          expect(page).to have_content '追加したタスク'
          expect(page).not_to have_content '最初のタスク'
          expect(page).not_to have_content '２番目のタスク'
          expect(page).not_to have_content '最後のタスク'
        end

        it '完了のみが表示される' do
          select '完了', from: 'status'
          click_button 'commit'

          expect(page).not_to have_content '追加したタスク'
          expect(page).not_to have_content '最初のタスク'
          expect(page).to have_content '２番目のタスク'
          expect(page).not_to have_content '最後のタスク'
        end

        it '全て表示される' do
          select '全て', from: 'status'
          click_button 'commit'

          expect(page).to have_content '追加したタスク'
          expect(page).to have_content '最初のタスク'
          expect(page).to have_content '２番目のタスク'
          expect(page).to have_content '最後のタスク'
        end
      end

      context '異なるユーザーのタスクは検索できない' do
        it '検索結果がない' do
          fill_in 'keyword', with: '花子のタスク'
          click_button 'commit'

          expect(page).not_to have_content '花子のタスク'
        end
      end
    end

    describe 'ページング機能' do
      context 'ページングが動作しているか' do
        it '２ページ目のタスクが表示されている' do
          create_list(:task, 10, user_id: user_taro.id)

          visit tasks_path
          click_link '2'
          expect(find('li:nth-child(1)')).to have_content 'test_task_4'
        end
      end
    end
  end

  describe 'タスク詳細' do
    context '詳細画面に遷移し、内容を確認する' do
      it '表示される詳細画面の情報が期待通り' do
        visit tasks_path

        click_link '最初のタスク'
        expect(page).to have_content '最初のタスク'
        expect(page).to have_content '説明文'
        expect(page).to have_content '2021年09月01日(水) 10:00 〜 2021年09月02日(木) 11:00'
      end
    end

    context '異なるユーザーのタスク' do
      it '詳細情報が表示されず、404ページが表示される' do
        visit task_path(hanako_task)

        expect(page).to have_content '404 NOT FOUND'
      end
    end
  end

  describe 'タスク新規作成' do
    context '新規作成画面でタスクを作成する' do
      it '期待通りの新規タスクが作成され、既存データに影響がない' do
        visit new_task_path
        fill_in 'タスク名', with: '作ったタスク'
        fill_in '内容', with: 'タスクの内容'
        fill_in 'ラベル', with: '開発'
        fill_in 'task[start_at]', with: '002021-10-01-01:02'
        fill_in 'task[due_date_at]', with: '002021-10-02-03:04'

        click_button 'commit'

        # 作成されたタスクが表示されている
        expect(find('.task-list > li:nth-child(1)')).to have_content '作ったタスク'
        expect(find('.task-list > li:nth-child(1) > .label-list > li:nth-child(1)')).to have_content '開発'
        expect(find('.task-list > li:nth-child(1)')).to have_content '2021年10月01日(金) 01:02 〜 2021年10月02日(土) 03:04'

        # 既存のデータに影響がない
        expect(find('.task-list > li:nth-child(2)')).to have_content '最初のタスク'
        expect(find('.task-list > li:nth-child(2)')).to have_content '2021年09月01日(水) 10:00 〜 2021年09月02日(木) 11:00'
        expect(find('.task-list > li:nth-child(3)')).to have_content '２番目のタスク'
        expect(find('.task-list > li:nth-child(3)')).to have_content '2021年08月02日(月) 10:00 〜 2021年08月03日(火) 11:00'
        expect(find('.task-list > li:nth-child(4)')).to have_content '追加したタスク'
        expect(find('.task-list > li:nth-child(4)')).to have_content '2021年10月01日(金) 10:00 〜 2021年10月03日(日) 11:00'
        expect(find('.task-list > li:nth-child(5)')).to have_content '最後のタスク'
        expect(find('.task-list > li:nth-child(5)')).to have_content '2021年12月02日(木) 10:00 〜 2021年12月03日(金) 11:00'

        # 詳細画面で作成したタスクの内容を確認
        click_link '作ったタスク'
        expect(page).to have_content '作ったタスク'
        expect(page).to have_content 'タスクの内容'
        expect(page).to have_content '2021年10月01日(金) 01:02 〜 2021年10月02日(土) 03:04'
        expect(find('.label-list > li:nth-child(1)')).to have_content '開発'
      end
    end
  end

  describe 'タスク新規作成のバリデーション' do
    context '入力誤り' do
      it 'エラー表示' do
        visit new_task_path
        fill_in 'ラベル', with: ",#{'a' * 21}"

        click_button 'commit'
        # 編集画面に戻り、エラーが表示されている
        expect(page).to have_content 'タスクを新規作成'
        expect(page).to have_content 'タスク名を入力してください'
        expect(page).to have_content '開始日を入力してください'
        expect(page).to have_content '開始日の指定が不正です。'
        expect(page).to have_content '終了日を入力してください'
        expect(page).to have_content '終了日の指定が不正です。'
        expect(page).to have_content 'ラベル名を入力してください'
        expect(page).to have_content 'ラベル名は20文字以内で入力してください'
      end
    end
  end

  describe 'タスク編集' do
    context 'タスクを編集する' do
      it '期待通りにタスクが編集され、既存データに影響がない' do
        visit tasks_path
        find('li:nth-child(1)').click_link('編集')
        fill_in 'タスク名', with: '最初のタスクを編集'
        fill_in '内容', with: 'タスクの内容を編集'
        fill_in 'ラベル', with: '開発,テスト'
        fill_in 'task[start_at]', with: '002021-10-11-11:12'
        fill_in 'task[due_date_at]', with: '002021-10-12-13:14'

        click_button 'commit'
        # 編集されたタスクが表示されている
        expect(find('.task-list > li:nth-child(1)')).to have_content '最初のタスクを編集'
        expect(find('.task-list > li:nth-child(1) > .label-list > li:nth-child(1)')).to have_content '開発'
        expect(find('.task-list > li:nth-child(1) > .label-list > li:nth-child(2)')).to have_content 'テスト'
        expect(find('.task-list > li:nth-child(1)')).to have_content '2021年10月11日(月) 11:12 〜 2021年10月12日(火) 13:14'

        # 既存のデータに影響がない
        expect(find('.task-list > li:nth-child(2)')).to have_content '２番目のタスク'
        expect(find('.task-list > li:nth-child(2)')).to have_content '2021年08月02日(月) 10:00 〜 2021年08月03日(火) 11:00'
        expect(find('.task-list > li:nth-child(3)')).to have_content '追加したタスク'
        expect(find('.task-list > li:nth-child(3)')).to have_content '2021年10月01日(金) 10:00 〜 2021年10月03日(日) 11:00'
        expect(find('.task-list > li:nth-child(4)')).to have_content '最後のタスク'
        expect(find('.task-list > li:nth-child(4)')).to have_content '2021年12月02日(木) 10:00 〜 2021年12月03日(金) 11:00'

        # 詳細画面で編集したタスクの内容を確認
        click_link '最初のタスクを編集'
        expect(page).to have_content '最初のタスクを編集'
        expect(page).to have_content 'タスクの内容を編集'
        expect(find('.label-list > li:nth-child(1)')).to have_content '開発'
        expect(find('.label-list > li:nth-child(2)')).to have_content 'テスト'
        expect(page).to have_content '2021年10月11日(月) 11:12 〜 2021年10月12日(火) 13:14'
      end
    end

    context '異なるユーザーのタスク' do
      it '編集画面が表示されず、404ページが表示される' do
        visit edit_task_path(hanako_task)

        expect(page).to have_content '404 NOT FOUND'
      end
    end
  end

  describe 'タスク編集のバリデーション' do
    context '入力誤り' do
      it 'エラー表示' do
        visit tasks_path
        find('li:nth-child(1)').click_link('編集')
        fill_in 'タスク名', with: ''
        fill_in '内容', with: ''
        fill_in 'ラベル', with: ",#{'a' * 21}"
        fill_in 'task[start_at]', with: ''
        fill_in 'task[due_date_at]', with: ''

        click_button 'commit'
        # 編集画面に戻り、エラーが表示されている
        expect(page).to have_content 'タスクを編集'
        expect(page).to have_content 'タスク名を入力してください'
        expect(page).to have_content '開始日を入力してください'
        expect(page).to have_content '開始日の指定が不正です。'
        expect(page).to have_content '終了日を入力してください'
        expect(page).to have_content '終了日の指定が不正です。'
        expect(page).to have_content 'ラベル名を入力してください'
        expect(page).to have_content 'ラベル名は20文字以内で入力してください'
      end
    end
  end

  describe 'タスクの削除' do
    context 'タスクを削除する' do
      it '期待通りにタスクが削除され、既存データに影響がない' do
        visit tasks_path
        find('li:nth-child(1)').click_button('×')
        page.driver.browser.switch_to.alert.accept

        # 作成されたタスクが表示されてない
        expect(page).not_to have_content '最初のタスク'
        expect(page).not_to have_content '2021年09月01日(水) 10:00 〜 2021年09月02日(木) 11:00'

        # 既存のデータに影響がない
        expect(find('.task-list > li:nth-child(1)')).to have_content '２番目のタスク'
        expect(find('.task-list > li:nth-child(1)')).to have_content '2021年08月02日(月) 10:00 〜 2021年08月03日(火) 11:00'
        expect(find('.task-list > li:nth-child(2)')).to have_content '追加したタスク'
        expect(find('.task-list > li:nth-child(2)')).to have_content '2021年10月01日(金) 10:00 〜 2021年10月03日(日) 11:00'
        expect(find('.task-list > li:nth-child(3)')).to have_content '最後のタスク'
        expect(find('.task-list > li:nth-child(3)')).to have_content '2021年12月02日(木) 10:00 〜 2021年12月03日(金) 11:00'
      end
    end
  end

  describe 'アソシエーション' do
    let(:rspec_session) { { user_id: user_hanako.id } }

    context 'ユーザーが異なる' do
      it '一覧が切り替わる' do
        visit tasks_path
        expect(page).to have_content '花子のタスク'
        expect(page).not_to have_content '２番目のタスク'
        expect(page).not_to have_content '最初のタスク'
        expect(page).not_to have_content '追加したタスク'
        expect(page).not_to have_content '最後のタスク'
      end
    end
  end
end
