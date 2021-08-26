# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  before { travel_to Date.new(2015, 1, 1) }
  let!(:task) { FactoryBot.create(:task) }

  context '一覧ページの確認' do
    # Task一覧画面を開く
    let!(:new_task) { FactoryBot.create(:new_task) }
    before { visit tasks_path }

    it '一覧表示されているかの確認' do
      # 画面を検証する
      expect(page).to have_content 'a_task'
    end

    context 'ソートの確認' do
      it '初期のsort順序が日付の降順になっていることの確認' do
        expect(page).to have_selector '#task-0', text: '2021-08-02'
        expect(page).to have_selector '#task-1', text: '2019-09-02'
      end

      it 'タスク名のボタンを押した際のsort確認' do
        # 初期でタスク名ボタンを押した際はタスク名の昇順になる。
        find('a', text: 'タスク名').click
        expect(page).to have_selector '#task-0', text: 'a_task'
        expect(page).to have_selector '#task-1', text: 'b_task'

        # 二回目にタスク名ボタンを押した際はタスク名の降順になる。
        find('a', text: 'タスク名').click
        expect(page).to have_selector '#task-0', text: 'b_task'
        expect(page).to have_selector '#task-1', text: 'a_task'
      end

      it '作成日ボタンを押した際のsort確認' do
        # 初期で作成日ボタンを押した際は作成日の昇順になる。
        find('a', text: '作成日').click
        expect(page).to have_selector '#task-0', text: '2019-09-02'
        expect(page).to have_selector '#task-1', text: '2021-08-02'

        # 二回目に作成日ボタンを押した際は作成日の降順になる。
        find('a', text: '作成日').click
        expect(page).to have_selector '#task-0', text: '2021-08-02'
        expect(page).to have_selector '#task-1', text: '2019-09-02'
      end

      it '締め切りボタンを押した際のsort確認' do
        # 初期で作成日ボタンを押した際は作成日の昇順になる。
        find('a', text: '締め切り').click
        expect(page).to have_selector '#task-0', text: (Time.current + 2.days).strftime('%F')
        expect(page).to have_selector '#task-1', text: (Time.current + 10.days).strftime('%F')

        # 二回目に作成日ボタンを押した際は作成日の降順になる。
        find('a', text: '締め切り').click
        expect(page).to have_selector '#task-0', text: (Time.current + 10.days).strftime('%F')
        expect(page).to have_selector '#task-1', text: (Time.current + 2.days).strftime('%F')
      end
    end

    context '検索の確認' do
      it 'bで検索した際にb_taskが表示される' do
        fill_in 'keyword_name', with: 'b'
        click_button '検索'
        expect(page).to have_selector '#task-0', text: 'b_task'
        expect(page).to have_no_text 'a_task'
      end

      it '未着手で検索した際にb_taskが表示される' do
        select '未着手', from: 'keyword_progress'
        click_button '検索'
        expect(page).to have_selector '#task-0', text: 'b_task'
        expect(page).to have_no_text 'a_task'
      end

      it '進行中で検索した際にb_taskが表示される' do
        select '進行中', from: 'keyword_progress'
        click_button '検索'
        expect(page).to have_selector '#task-0', text: 'a_task'
        expect(page).to have_no_text 'b_task'
      end

      it '済で検索した際にb_taskが表示される' do
        select '済', from: 'keyword_progress'
        click_button '検索'
        expect(page).to have_no_text 'a_task'
        expect(page).to have_no_text 'b_task'
      end

      context '検索状態でのソート確認' do
        before {
          fill_in 'keyword_name', with: 'task'
          click_button '検索'
        }

        it 'taskで検索した状態でのソート確認' do
          # 初期でタスク名ボタンを押した際はタスク名の昇順になる。
          find('a', text: 'タスク名').click
          expect(page).to have_selector '#task-0', text: 'a_task'
          expect(page).to have_selector '#task-1', text: 'b_task'

          # 二回目にタスク名ボタンを押した際はタスク名の降順になる。
          find('a', text: 'タスク名').click
          expect(page).to have_selector '#task-0', text: 'b_task'
          expect(page).to have_selector '#task-1', text: 'a_task'
        end
      end
    end

    context 'peginationの確認' do
      # 合計25個のtaskが作られる
      let!(:new_task) { create_list(:task, 24) }

      it '初期ページの確認後、最後のページの移行し、要素の確認' do
        navs = page.all('nav')
        expect(navs[0]).to have_css(".next")
        expect(navs[0]).to have_css(".last")
        expect(navs[0]).to have_content '1'
        expect(navs[0]).to have_content '3'
        expect(navs[0]).to have_no_content '4'

        expect(page).to have_selector '#task-9'
        expect(page).to have_no_selector '#task-10'

        # 最後のページの確認
        find('a', text: '最後').click
        expect(page).to have_selector '#task-4'
        expect(page).to have_no_selector '#task-5'
      end

      it '次へボタンの確認' do
        # 次へボタンの確認
        find('a', text: '次').click
        expect(page).to have_selector '#task-9'
        expect(page).to have_no_selector '#task-10'
      end

      it '前へボタンの確認' do
        find('a', text: '3').click
        find('a', text: '前').click
        expect(page).to have_selector '#task-9'
        expect(page).to have_no_selector '#task-10'
      end

      it '最初へボタンの確認' do
        find('a', text: '3').click
        find('a', text: '最初').click
        expect(page).to have_selector '#task-9'
        expect(page).to have_no_selector '#task-10'
      end
      
    end
  end

  it '詳細ページの確認' do
    # Task編集画面を開く
    visit task_path(task)

    # 画面を検証する
    expect(page).to have_content 'a_task'
    expect(page).to have_content 'Memo'
    expect(page).to have_content '中'
    expect(page).to have_content '進行中'
  end

  context '編集が行われているかの確認' do
    # Task編集画面を開く
    before { visit edit_task_path(task) }

    it '既存のタスク内容が書いている' do
      expect(page).to have_field 'メモ', with: 'Memo'
    end

    it 'タスクを編集できる' do
      # メモに"Memo"が入力されていることを検証する
      # メモを再入力
      fill_in 'メモ', with: 'MyText'

      # 更新実行
      click_button '投稿'

      # 画面を検証する
      expect(page).to have_content 'タスクが編集されました'
      expect(page).to have_content 'a_task'
      expect(page).to have_content 'MyText'
    end
  end

  context '新規作成できるかの確認' do
    # Task新規作成画面を開く
    before { visit new_task_path }

    it '全ての項目を入力して成功する' do
      # タスクを入力
      fill_in 'タスク', with: 'Task'
      # メモを入力
      fill_in 'メモ', with: 'Memo'
      # 締め切りを入力
      fill_in '締め切り', with: '2021-08-17 10:59:26'
      # 優先順位を入力
      select '中', from: '優先順位'
      # 進捗状況を入力
      select '進行中', from: '進捗状況'
      # 更新実行
      click_button '投稿'

      # 画面を検証する
      expect(page).to have_content 'タスクが投稿されました'
      expect(page).to have_content 'Task'
      expect(page).to have_content 'Memo'
      expect(page).to have_content '中'
      expect(page).to have_content '進行中'
    end
  end

  it '削除の確認' do
    visit task_path(task)
    page.accept_confirm do
      click_on :delete_button
    end

    # 画面を検証する
    expect(page).to have_content 'タスクが削除されました'
  end
end
