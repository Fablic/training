require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  before do
    driven_by(:remote_chrome)
  end

  # TODO: バリデーションの実装は後で行うので、異常系のテストも後回し
  describe 'GET /' do
    it 'renders a successful response'do
      visit '/'
      expect(page).to have_content 'タスク 一覧'
    end
  end

  describe 'I18n' do
    context 'Default locale' do
      it 'shows Japanese pages'do
        visit '/'
        expect(page).to have_content 'タスク 一覧'
      end
    end

    context 'English locale' do
      it 'shows English pages'do
        visit '/?locale=en'
        expect(page).to have_content 'task'
      end
    end

    context 'Moving another page when English locale' do
      it 'takes over the locale setting and shows English pages'do
        visit '/?locale=en'
        expect(page).to have_content 'task list'
        click_link('add')
        expect(page).to have_content 'task new'
      end
    end
  end

end
