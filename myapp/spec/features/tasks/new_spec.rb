# frozen_string_literal: true

require 'rails_helper'

RSpec.feature '/task/new' do
  feature '#new' do
    given(:user) { create(:user) }

    scenario 'correctly displays task new form' do
      login(user)

      visit new_task_path

      expect(current_path).to eq '/tasks/new'
    end

    scenario 'renders #index' do
      login(user)

      visit new_task_path
      click_on '一覧に戻る'

      expect(current_path).to eq '/tasks'
      expect(page).to have_content 'タスク一覧'
    end

    scenario 'creates new task' do
      login(user)

      visit new_task_path

      expect(current_path).to eq '/tasks/new'

      fill_in 'タスク名', with: 'タスク名ッダーン!!'
      fill_in '終了期限', with: Time.current.to_s
      select '低', from: 'task[priority]'
      select '完了', from: 'task[status]'
      fill_in '説明', with: 'タスク的な説明なやつ'

      expect { click_button '登録する' }.to change(Task, :count).by(1)
      expect(Task.last.name).to eq 'タスク名ッダーン!!'
      expect(current_path).to eq "/tasks/#{Task.last.id}"
      expect(page).to have_content 'タスクが正常に作成されました'
    end

    scenario 'does not create no name task' do
      login(user)

      visit new_task_path

      expect(current_path).to eq '/tasks/new'

      fill_in 'タスク名', with: ''
      fill_in '終了期限', with: Time.current.to_s
      select '普通', from: 'task[priority]'
      select '着手中', from: 'task[status]'
      fill_in '説明', with: 'タスク的な説明なやつ'

      expect { click_button '登録する' }.to change(Task, :count).by(0)
      expect(current_path).to eq '/tasks'
      expect(page).to have_content '1件のエラーが発生しました'
      expect(page).to have_content 'タスク名を入力してください'
    end
  end
end
