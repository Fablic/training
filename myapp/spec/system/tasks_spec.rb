require 'rails_helper'

RSpec.describe 'index', js: true, type: :system do
  let!(:task_list) { FactoryBot.create_list(:task, 10) }

  describe 'Top(タスク一覧)ページ' do
    before { visit root_path }
    subject { page }

    it '一覧が表示されている' do
      is_expected.to have_content('タスク一覧')
      is_expected.to have_content(task_list[0].title)
    end
    it '一覧が作成日の降順で表示されている' do
      expect(page.all('.created').first.text).to be > page.all('.created').last.text
    end
    it '終了日時の早い順に並び替えられる' do
      select '終了期限早い'
      expect(page.all('.deadline').first.text).to be < page.all('.deadline').last.text
    end
    it '終了日時の遅い順に並び替えられる' do
      select '終了期限遅い'
      expect(page.all('.deadline').first.text).to be > page.all('.deadline').last.text
    end
    it '件名で検索できる' do
      fill_in 'q_title_cont', with: 'test_title1'
      click_button '検索'
      is_expected.to have_content('test_title1')
      is_expected.not_to have_content('test_title2')
    end
    it 'ステータス「未着手」で検索できる' do
      choose "q_status_eq_#{Task.statuses[:not_started]}"
      click_button '検索'
      within('.task_list') do
        is_expected.to have_content('未着手')
        is_expected.to have_no_content('進行中')
        is_expected.to have_no_content('完了')
      end
    end
    it '詳細へ遷移する' do
      click_link task_list[0].title
      is_expected.to have_current_path task_path(task_list[0].id)
    end
    it '新規作成へ遷移する' do
      click_link '新規作成'
      is_expected.to have_current_path new_task_path
    end
  end

  describe '詳細ページ' do
    before { visit task_path(task_list[0].id) }
    subject { page }

    it '詳細が表示されている' do
      is_expected.to have_content('タスク詳細')
      is_expected.to have_content(task_list[0].title)
      is_expected.to have_content(task_list[0].content)
    end
    it '一覧へ遷移する' do
      click_link '一覧に戻る'
      is_expected.to have_current_path tasks_path
    end
    it '編集へ遷移する' do
      click_link '編集ページへ'
      is_expected.to have_current_path edit_task_path(task_list[0].id)
    end
    context '削除実行する' do
      it '削除される' do
        page.accept_confirm('本当によろしいですか？') do
          click_link '削除する'
        end
        is_expected.to have_content 'タスクが削除されました'
        is_expected.to have_current_path tasks_path
        is_expected.not_to have_content(task_list[0].title)
      end
    end
    context '削除実行しない' do
      it '削除されない' do
        page.dismiss_confirm('本当によろしいですか？') do
          click_link '削除する'
        end
        is_expected.to have_current_path task_path(task_list[0].id)
      end
    end
  end

  describe '新規作成ページ' do
    before { visit new_task_path }
    subject { page }

    context '入力エラーなし' do
      it 'タスクが作成できる' do
        is_expected.to have_content('タスクの作成')
        fill_in '件名', with: 'new 件名'
        fill_in '詳細', with: 'new 詳細'
        fill_in '終了期限', with: Time.current
        click_button '投稿'
        is_expected.to have_content 'タスク投稿が成功しました'
        is_expected.to have_current_path task_path(task_list.last.id + 1)
      end
    end
    context '件名が未入力' do
      it 'エラーが表示される' do
        fill_in '件名', with: ''
        fill_in '詳細', with: 'new 詳細'
        click_button '投稿'
        is_expected.to have_content 'タスク投稿が失敗しました'
        is_expected.to have_content '件名を入力してください'
        is_expected.to have_current_path new_task_path
      end
    end
    context '詳細が未入力' do
      it 'エラーが表示される' do
        fill_in '件名', with: 'new 件名'
        fill_in '詳細', with: ''
        click_button '投稿'
        is_expected.to have_content 'タスク投稿が失敗しました'
        is_expected.to have_content '詳細を入力してください'
        is_expected.to have_current_path new_task_path
      end
    end
  end

  describe '編集ページ' do
    before { visit edit_task_path(task_list[0].id) }
    subject { page }
    let(:params) { { title: 'edit 件名', content: 'edit 詳細' } }

    it 'タスクが表示される' do
      is_expected.to have_content('タスクの編集')
      is_expected.to have_field '件名', with: task_list[0].title
      is_expected.to have_field '詳細', with: task_list[0].content
    end
    context '入力エラーなし' do
      it 'タスクが編集できる' do
        fill_in '件名', with: params[:title]
        fill_in '詳細', with: params[:content]
        fill_in '終了期限', with: Time.current
        click_button '保存'
        is_expected.to have_current_path task_path(task_list[0].id)
        is_expected.to have_content 'タスク編集が成功しました'
        is_expected.to have_content(params[:title])
        is_expected.to have_content(params[:content])
      end
    end
    context '件名が未入力' do
      it 'エラーが表示される' do
        fill_in '件名', with: ''
        fill_in '詳細', with: params[:content]
        click_button '保存'
        is_expected.to have_content 'タスク編集が失敗しました'
        is_expected.to have_content '件名を入力してください'
        is_expected.to have_current_path edit_task_path(task_list[0].id)
      end
    end
    context '詳細が未入力' do
      it 'エラーが表示される' do
        fill_in '件名', with: params[:title]
        fill_in '詳細', with: ''
        click_button '保存'
        is_expected.to have_content 'タスク編集が失敗しました'
        is_expected.to have_content '詳細を入力してください'
        is_expected.to have_current_path edit_task_path(task_list[0].id)
      end
    end
  end
end
