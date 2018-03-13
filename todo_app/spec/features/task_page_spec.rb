# frozen_string_literal: true

require 'rails_helper'

describe 'タスク一覧画面', type: :feature do
  describe '画面にアクセス' do
    it 'ルートパスでアクセスできること' do
      visit '/'
      expect(page).to have_css('#todo_app_task_list')
    end
  end

  context '1件タスクが登録されている場合' do
    before { create(:task, title: 'Rspec test 1') }

    it '登録した1件のタスクがテーブルに表示されていること' do
      visit '/'
      expect(page).to have_css('table#task_table tbody tr', count: 1)
    end

    it 'タイトル列に参照画面のリンクが表示されていること' do
      visit '/'
      tr = first(:css, 'table#task_table tbody tr')
      expect(tr).to have_selector('a', text: 'Rspec test 1')
    end

    it '編集列の編集画面のリンクが表示されていること' do
      visit '/'
      tr = first(:css, 'table#task_table tbody tr')
      expect(tr).to have_selector('a.edit-button')
    end

    it '削除列に削除ボタンが表示されていること' do
      visit '/'
      tr = first(:css, 'table#task_table tbody tr')
      expect(tr).to have_selector('a.trash-button')
    end
  end

  context '複数のタスクが登録されている場合', type: :feature do
    before do
      (1..10).to_a.each { |i| create(:task, title: "Rspec test #{i}", created_at: "2018/1/1 0:0:#{i}") }
    end

    context '初期表示の場合' do
      it '絞り込み条件なしで全てのデータがテーブルに表示されていること' do
        visit '/'
        expect(page).to have_css('table#task_table tbody tr', count: 10)
      end

      it 'created_atの降順で表示されていること' do
        visit '/'
        all('table#task_table tbody tr').reverse_each.with_index do |td, idx|
          # 作成時に登録順でインクリメントしているので、idでソートされていると名前も昇順になっている
          expect(td).to have_selector('a', text: "Rspec test #{idx + 1}")
        end
      end
    end
  end

  describe '画面の表示内容を変更する' do
    describe 'ソート順を変更する' do
      before do
        (1..10).to_a.each { |i| create(:task, title: "Rspec test #{i}", deadline: "2018/2/#{11 - i} 01:01:01", created_at: "2018/1/1 0:0:#{i}") }

        visit '/'
        within('.card-text') do
          select Task.human_attribute_name("sort_kind.#{sort}"), from: 'sort'
        end
        click_on I18n.t('helpers.submit.search')
      end

      context '新着順でソートしたい場合' do
        let (:sort) { 'created_at' }

        it 'created_atの降順で表示されていること' do
          all('table#task_table tbody tr').each.with_index do |td, idx|
            expect(td).to have_content("2018/01/01 00:00:#{format('%02d', 10 - idx)}")
          end

          expect(page.find_by_id('sort').value).to eq 'created_at'
        end
      end

      context '期日が近い順でソートしたい場合' do
        let (:sort) { 'deadline' }

        it 'deadlineの降順で表示されていること' do
          all('table#task_table tbody tr').each.with_index do |td, idx|
            expect(td).to have_content("2018/02/#{format('%02d', 10 - idx)} 01:01:01")
          end

          expect(page.find_by_id('sort').value).to eq 'deadline'
        end
      end
    end
  end

  context 'タスクを登録したい場合' do
    it '作成ボタンが表示されること' do
      visit '/'
      expect(page).to have_button('add_task_button')
    end

    it 'タスク登録画面へ遷移できること' do
      visit '/'
      click_on 'add_task_button'
      expect(page).to have_selector(:css, '#add_task')
    end
  end

  context 'タスクを編集したい場合' do
    before { create(:task, title: 'Rspec test 1') }

    it 'タスク詳細画面へ遷移できること' do
      visit '/'
      first(:css, 'table#task_table tbody tr').find_link('Rspec test 1').click
      expect(page).to have_selector(:css, '#show_task')
    end

    it 'タスク編集画面へ遷移できること' do
      visit '/'
      first(:css, 'table#task_table tbody tr').find('td a.edit-button').click
      expect(page).to have_selector(:css, '#edit_task')
    end
  end

  context 'タスクの削除したい場合', type: :feature do
    before { create(:task, title: 'Rspec test 1') }

    context '確認ダイアログでキャンセルボタンを押した場合' do
      it '対象行は削除されないこと' do
        visit '/'

        expect(page).to have_css('table#task_table tbody tr', count: 1)
        first(:css, 'table#task_table tbody tr').find('td a.trash-button').click
        page.dismiss_confirm

        expect(page).to have_css('table#task_table tbody tr', count: 1)
      end
    end

    context '確認ダイアログで確認ボタンを押した場合' do
      it '処理が実行されタスクが削除されること' do
        visit '/'

        expect(page).to have_css('table#task_table tbody tr', count: 1)
        first(:css, 'table#task_table tbody tr').find('td a.trash-button').click
        page.accept_confirm

        expect(page).to have_css('.alert-success')
        expect(page).to have_css('table#task_table tbody tr', count: 0)
      end
    end
  end
end
