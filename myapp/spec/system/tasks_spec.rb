require 'rails_helper'

RSpec.describe 'Tasks', type: :system, js: true do
  # let(:user) { create(:user, name: "hoge") }
  describe 'Index' do
    before { visit root_path }

    context 'index画面にて各機能の確認' do
      it 'タスク一覧画面が表示される' do
        expect(page).to have_content('Tasks#index')
        expect(page).to have_content('タスク名')
        expect(page).to have_content('説明')
        expect(page).to have_content('詳細')
        expect(page).to have_content('編集')
        expect(page).to have_content('削除')
      end

      it 'タスク作成画面に遷移できる' do
        click_link 'Create task'
        expect(page).to have_content('Tasks#new')
      end
    end
  end
end
