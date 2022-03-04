require 'rails_helper'

RSpec.describe 'Tasks', type: :system do

  feature 'タスク一覧(登録タスクが0件)' do
    background do
      Capybara.current_driver = Capybara.javascript_driver
    end

    context '画面に表示する項目' do
      it '必要な項目が表示されている' do
        # タスク一覧画面を開く
        visit tasks_path

        expect(page).to have_content 'タスク一覧'
        # ０件メッセージ確認
        expect(page).to have_content 'タスクが登録されていません'
      end
    end
  end

  feature 'タスク一覧' do
    background do
      Capybara.current_driver = Capybara.javascript_driver
      @task1 = FactoryBot.create(:task)
    end

    context '画面に表示する項目' do
      it '必要な項目が表示されている' do
        # タスク一覧画面を開く
        visit tasks_path

        expect(page).to have_content 'タスク一覧'

        expect(page).to have_link 'タスク作成'

        expect(page).to have_content 'タスク名'
        expect(page).to have_content 'ステータス'
        expect(page).to have_content '終了期限'
        expect(page).to have_content 'ラベル'

        expect(page).to have_link @task1.title
        expect(page).to have_content @task1.status
        expect(page).to have_content @task1.deadline
        expect(page).to have_link '編集'
        expect(page).to have_link '削除'
      end
    end

    context 'タスク名をクリックする' do
      it 'タスク詳細画面へ遷移する' do
        # タスク一覧画面を開く
        visit tasks_path
        click_link @task1.title

        expect(page).to have_content 'タスク詳細'
      end
    end

    context 'タスク作成リンクをクリックする' do
      it 'タスク作成画面へ遷移する' do
        # タスク一覧画面を開く
        visit tasks_path
        click_link 'タスク作成'

        expect(page).to have_content 'タスク作成'
      end
    end

    context '編集リンクをクリックする' do
      it 'タスク編集画面へ遷移する' do
        # タスク一覧画面を開く
        visit tasks_path
        click_link '編集', match: :first

        expect(page).to have_content 'タスク編集'
      end
    end

    context '削除リンクをクリックする' do
      it '削除確認ダイアログを表示する' do
        # タスク一覧画面を開く
        visit tasks_path
        click_link '削除', match: :first

        expect(page.driver.browser.switch_to.alert.text).to eq "削除します。よろしいですか？"
      end
    end
  end

  feature 'タスク詳細' do
    background do
      Capybara.current_driver = Capybara.javascript_driver
      @task1 = FactoryBot.create(:task)
    end

    context '画面に表示する項目' do
      it '必要な項目が表示されている' do
        # タスク詳細画面を開く
        visit task_path(1)

        expect(page).to have_content 'タスク詳細'

        expect(page).to have_link '一覧へ'
    
        expect(page).to have_content 'タスク名'
        expect(page).to have_content '内容'
        expect(page).to have_content '終了期限'
        expect(page).to have_content '優先順位'
        expect(page).to have_content 'ステータス'
        expect(page).to have_content 'ラベル'
    
        expect(page).to have_content 'テストタスク_1'
        expect(page).to have_content 'テスト内容_1'
        expect(page).to have_content '2022-03-10'
        expect(page).to have_content 'middle'
        expect(page).to have_content '未着手'
      end
    end

    context '一覧へリンクをクリックする' do
      it 'タスク一覧画面へ遷移する' do
        # タスク詳細画面を開く
        visit task_path(1)
        click_link '一覧へ'

        expect(page).to have_content 'タスク一覧'
      end
    end
  end

  feature 'タスク作成' do
    background do
      Capybara.current_driver = Capybara.javascript_driver
    end

    context '画面に表示する項目' do
      it '必要な項目が表示されている' do
        # タスク作成画面を開く
        visit new_task_path
    
        expect(page).to have_content 'タスク作成'
    
        expect(page).to have_link '一覧へ'
    
        expect(page).to have_field 'タスク名', with: ''
        expect(page).to have_field '内容', with: ''
        expect(page).to have_field '終了期限', with: ''
        expect(page).to have_field '優先順位', with: 'high'
        expect(page).to have_field 'ステータス', with: '未着手'
        expect(page).to have_field 'ラベル', with: ''
    
        expect(page).to have_button '登録'
      end
    end

    context '一覧へリンクをクリックする' do
      it 'タスク一覧画面へ遷移する' do
        # タスク作成画面を開く
        visit new_task_path
        click_link '一覧へ'

        expect(page).to have_content 'タスク一覧'
      end
    end

    context '項目を入力して、登録ボタンをクリックする' do
      it '新規タスクを保存して、タスク詳細画面へ遷移する' do
        # タスク作成画面を開く
        visit new_task_path

        # タスク作成：入力
        fill_in 'task[title]', with: 'お試しタスク'
        fill_in 'task[body]', with: 'ないよー'
        fill_in 'task[deadline]', with: '03-10-2022' # mm-dd-yyyy
        select 'middle', from: 'task[priority]'
        select '着手', from: 'task[status]'

        click_button '登録'

        # タスク詳細画面へ遷移
        expect(page).to have_content 'タスク詳細'

        # 保存成功メッセージ
        expect(page).to have_content '保存しました'
        # 保存内容
        expect(page).to have_content 'お試しタスク'
        expect(page).to have_content 'ないよー'
        expect(page).to have_content '2022-03-10'
        expect(page).to have_content 'middle'
        expect(page).to have_content '着手'
      end
    end
  end

  feature 'タスク編集' do
    background do
      Capybara.current_driver = Capybara.javascript_driver
      @task1 = FactoryBot.create(:task)
    end

    context '画面に表示する項目' do
      it '必要な項目が表示されている' do
        # タスク編集画面を開く
        visit edit_task_path(1)
    
        expect(page).to have_content 'タスク編集'
    
        expect(page).to have_link '一覧へ'
    
        expect(page).to have_field 'タスク名', with: 'テストタスク_1'
        expect(page).to have_field '内容', with: 'テスト内容_1'
        expect(page).to have_field '終了期限', with: '2022-03-10'
        expect(page).to have_field '優先順位', with: 'middle'
        expect(page).to have_field 'ステータス', with: '未着手'
        expect(page).to have_field 'ラベル', with: ''
    
        expect(page).to have_button '登録'
      end
    end

    context '一覧へリンクをクリックする' do
      it 'タスク一覧画面へ遷移する' do
        # タスク編集画面を開く
        visit edit_task_path(1)
        click_link '一覧へ'

        expect(page).to have_content 'タスク一覧'
      end
    end

    context '項目を入力して、登録ボタンをクリックする' do
      it '新規タスクを保存して、タスク詳細画面へ遷移する' do
        # タスク編集画面を開く
        visit edit_task_path(1)

        # 修正入力
        fill_in 'task[body]', with: '内容ないよー'
        fill_in 'task[deadline]', with: '03-09-2022' #mm-dd-yyyy
        select '完了', from: 'task[status]'

        click_button '登録'

        # タスク詳細画面へ遷移
        expect(page).to have_content 'タスク詳細'

        # 保存成功メッセージ
        expect(page).to have_content '保存しました'
        # 保存内容
        expect(page).to have_content 'テストタスク_1'
        expect(page).to have_content '内容ないよー'
        expect(page).to have_content '2022-03-09'
        expect(page).to have_content 'middle'
        expect(page).to have_content '完了'
      end
    end
  end

  feature 'タスク削除' do
    background do
      Capybara.current_driver = Capybara.javascript_driver
      @task1 = FactoryBot.create(:task)
    end

    context 'タスク一覧画面で削除をクリックする' do
      it '一覧からタスクが削除されている' do
        # タスク一覧画面を開く
        visit tasks_path
        # タスクの存在確認
        expect(page).to have_content 'テストタスク_1'
        # タスク削除
        click_link '削除', match: :first

        # ダイアログ表示確認
        page.driver.browser.switch_to.alert.accept

        # タスク一覧画面へ遷移
        expect(page).to have_content 'タスク一覧'
        # 削除成功メッセージ
        expect(page).to have_content '削除しました'
        # お試しタスクの削除確認
        expect(page).not_to have_content 'テストタスク_1'
      end
    end
  end
end
