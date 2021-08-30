require 'rails_helper'

RSpec.describe 'index', js: true, type: :system do
  let!(:task_list) { FactoryBot.create_list(:task, 100) }

  describe 'Top(タスク一覧)ページ' do
    subject { visit root_path }
    it '一覧が表示されている' do
      subject
      expect(page).to have_content('タスク一覧')
      expect(page).to have_content(task_list[0].title)
    end
    it '一覧が作成日の降順で表示されている' do
      subject
      expect(page.all('.created').first.text).to be > page.all('.created').last.text
    end
    it '詳細へ遷移する' do
      subject
      click_link task_list[0].title
      expect(current_path).to eq task_path(task_list[0].id)
    end
    it '新規作成へ遷移する' do
      subject
      click_link '新規作成'
      expect(current_path).to eq new_task_path
    end
  end

  describe '詳細ページ' do
    subject { visit task_path(task_list[0].id) }
    it '詳細が表示されている' do
      subject
      expect(page).to have_content('タスク詳細')
      expect(page).to have_content(task_list[0].title)
      expect(page).to have_content(task_list[0].content)
    end
    it '一覧へ遷移する' do
      subject
      click_link '一覧に戻る'
      expect(current_path).to eq tasks_path
    end
    it '編集へ遷移する' do
      subject
      click_link '編集ページへ'
      expect(current_path).to eq edit_task_path(task_list[0].id)
    end
    context '削除実行する' do
      it '削除される' do
        subject
        page.accept_confirm('本当によろしいですか？') do
          click_link '削除する'
        end
        expect(page).to have_content 'タスクが削除されました'
        expect(current_path).to eq tasks_path
        expect(page).not_to have_content(task_list[0].title)
      end
    end
    context '削除実行しない' do
      it '削除されない' do
        subject
        page.dismiss_confirm('本当によろしいですか？') do
          click_link '削除する'
        end
        expect(current_path).to eq task_path(task_list[0].id)
      end
    end
  end

  describe '新規作成ページ' do
    subject { visit new_task_path }

    context '入力エラーなし' do
      it 'タスクが作成できる' do
        subject
        expect(page).to have_content('タスクの作成')
        fill_in '件名', with: 'new 件名'
        fill_in '詳細', with: 'new 詳細'
        click_button '投稿'
        expect(page).to have_content 'タスク投稿が成功しました'
        expect(current_path).to eq task_path(task_list.last.id + 1)
      end
    end
    context '件名が未入力' do
      it 'エラーが表示される' do
        subject
        fill_in '件名', with: ''
        fill_in '詳細', with: 'new 詳細'
        click_button '投稿'
        expect(page).to have_content 'タスク投稿が失敗しました'
        expect(page).to have_content '件名を入力してください'
        expect(current_path).to eq new_task_path
      end
    end
    context '詳細が未入力' do
      it 'エラーが表示される' do
        subject
        fill_in '件名', with: 'new 件名'
        fill_in '詳細', with: ''
        click_button '投稿'
        expect(page).to have_content 'タスク投稿が失敗しました'
        expect(page).to have_content '詳細を入力してください'
        expect(current_path).to eq new_task_path
      end
    end
  end

  describe '編集ページ' do
    subject { visit edit_task_path(task_list[0].id) }
    let(:params) { { title: 'edit 件名', content: 'edit 詳細' } }

    it 'タスクが表示される' do
      subject
      expect(page).to have_content('タスクの編集')
      expect(page).to have_field '件名', with: task_list[0].title
      expect(page).to have_field '詳細', with: task_list[0].content
    end
    context '入力エラーなし' do
      it 'タスクが編集できる' do
        subject
        fill_in '件名', with: params[:title]
        fill_in '詳細', with: params[:content]
        click_button '保存'
        expect(current_path).to eq task_path(task_list[0].id)
        expect(page).to have_content 'タスク編集が成功しました'
        expect(page).to have_content(params[:title])
        expect(page).to have_content(params[:content])
      end
    end
    context '件名が未入力' do
      it 'エラーが表示される' do
        subject
        fill_in '件名', with: ''
        fill_in '詳細', with: params[:content]
        click_button '保存'
        expect(page).to have_content 'タスク編集が失敗しました'
        expect(page).to have_content '件名を入力してください'
        expect(current_path).to eq edit_task_path(task_list[0].id)
      end
    end
    context '詳細が未入力' do
      it 'エラーが表示される' do
        subject
        fill_in '件名', with: params[:title]
        fill_in '詳細', with: ''
        click_button '保存'
        expect(page).to have_content 'タスク編集が失敗しました'
        expect(page).to have_content '詳細を入力してください'
        expect(current_path).to eq edit_task_path(task_list[0].id)
      end
    end
  end
end
