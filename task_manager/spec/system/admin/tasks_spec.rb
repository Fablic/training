# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Tasks', type: :system do
  let!(:task) { create(:task) }
  let!(:admin_user) { create(:admin_user) }
  let(:rspec_session) { { user_id: admin_user.id } }

  describe '一覧ページ' do
    # Task一覧画面を開く
    let!(:new_task) { create(:new_task, user_id: task.user_id) }
    before { visit admin_user_tasks_path(task.user) }

    context '初期表示' do
      it '一覧表示されているかの確認' do
        # 画面を検証する
        expect(page).to have_content 'a_task'
      end
    end

    describe 'ソート' do
      context '初期表示' do
        it 'sort順序が日付の降順になっていることの確認' do
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
    end

    describe '検索' do
      context 'bで検索' do
        before {
          fill_in 'keyword_name', with: 'b'
          click_button '検索'
        }
        it 'b_taskが表示される' do
          expect(page).to have_selector '#task-0', text: 'b_task'
          expect(page).to have_no_text 'a_task'
        end
      end

      context '未着手で検索' do
        before {
          select '未着手', from: 'keyword_progress'
          click_button '検索'
        }
        it 'b_taskが表示される' do
          expect(page).to have_selector '#task-0', text: 'b_task'
          expect(page).to have_no_text 'a_task'
        end
      end

      context '進行中で検索' do
        before {
          select '進行中', from: 'keyword_progress'
          click_button '検索'
        }
        it 'a_taskが表示される' do
          expect(page).to have_selector '#task-0', text: 'a_task'
          expect(page).to have_no_text 'b_task'
        end
      end

      context '済で検索' do
        before {
          select '済', from: 'keyword_progress'
          click_button '検索'
        }
        it 'b_taskが表示される' do
          expect(page).to have_no_text 'a_task'
          expect(page).to have_no_text 'b_task'
        end
      end

      context '検索状態' do
        before {
          fill_in 'keyword_name', with: 'task'
          click_button '検索'
        }

        it 'ソート確認' do
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

    describe 'ページネーション' do
      # 上記の宣言taskと合わせて合計25個のtaskが作られる
      before {
        create_list(:new_task, 23, user_id: task.user_id)
        visit admin_user_tasks_path(task.user)
      }

      context '初期ページ' do
        it 'ナビゲーションが正しく表示される' do
          navs = page.all('nav')
          expect(navs[1]).to have_content '次'
          expect(navs[1]).to have_content '最後'
          expect(navs[1]).to have_content '1'
          expect(navs[1]).to have_content '3'
          expect(navs[1]).to have_no_content '4'
        end

        it '1ページ目のタスクが表示される' do
          expect(page).to have_selector '#task-9'
          expect(page).to have_no_selector '#task-10'
        end

        context '次ボタンを押す' do
          before { find('a', text: '次').click }
          it '10件目のタスクが表示され、11件目は表示されない' do
            expect(page).to have_selector '#task-9'
            expect(page).to have_no_selector '#task-10'
          end
        end
      end

      context '最終ページ' do
        before { find('a', text: '最後').click }
        it '最後のページのタスクとして、6つめのタスクが表示されず、5つめのタスクが表示される' do
          wait = Selenium::WebDriver::Wait.new(timeout: 100)
          wait.until { expect(page).to have_no_selector '#task-5' }

          expect(page).to have_selector '#task-4'
        end

        context '前ボタンを押す' do
          before { find('a', text: '前').click }
          it '10件目のタスクが表示され、11件目は表示されない' do
            expect(page).to have_selector '#task-9'
            expect(page).to have_no_selector '#task-10'
          end
        end

        context '最初ボタンを押す' do
          before { find('a', text: '最初').click }
          it '10件目のタスクが表示され、11件目は表示されない' do
            expect(page).to have_selector '#task-9'
            expect(page).to have_no_selector '#task-10'
          end
        end
      end
    end
  end
end
