require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  before do
    driven_by(:remote_chrome)
  end

  # TODO: バリデーションの実装は後で行うので、異常系のテストも後回し
  describe 'GET /' do
    before do
      visit '/'
    end
    it 'renders tasks list page' do
      expect(page).to have_content 'タスク 一覧'
    end
  end

  describe 'GET /tasks' do
    before do
      create(:task, name: 'sample_task')
      visit '/tasks'
    end
    it 'renders a successful response' do
      expect(page).to have_content 'タスク 一覧'
      expect(page).to have_content 'sample_task'
    end
  end

  describe 'GET /tasks/:id' do
    before do
      @tasks = create(:task, name: 'sample_task')
      visit "/tasks/#{@tasks.id}"
    end
    it 'renders a successful response' do
      expect(page).to have_content 'タスク 詳細'
      expect(page).to have_content 'sample_task'
    end
  end

  describe 'GET /tasks/new' do
    before do
      visit '/tasks/new'
    end
    it 'renders tasks list page' do
      expect(page).to have_content 'タスク 新規'
    end
  end

  describe 'GET /tasks/:id/edit' do
    before do
      @tasks = create(:task, name: 'sample_task')
      visit "/tasks/#{@tasks.id}/edit"
    end
    it 'renders a successful response' do
      expect(page).to have_content 'タスク 編集'
      expect(page).to have_selector 'input[value="sample_task"]'
    end
  end

  describe 'Creating a new task successfully' do
    before do
      visit "/tasks"
      click_link('追加')
    end
    it 'successfully create a task' do
      expect(Task.all.length).to eq 0
      fill_in 'task[name]', with: 'sample_task'
      find('input[type="submit"]').click
      expect(page).to have_content 'タスクが正常に登録されました。'
      expect(page).to have_content 'タスク 詳細'
      expect(page).to have_content 'sample_taask'
      expect(Task.all.length).to eq 1
    end
  end

  describe 'Updating a task successfully' do
    before do
      @tasks = create(:task, name: 'sample_task')
      visit "/tasks/#{@tasks.id}/edit"
    end
    it 'successfully update a task' do
      fill_in 'task[name]', with: 'hoge_task'
      find('input[type="submit"]').click
      expect(page).to have_content 'タスクが正常に更新されました。'
      expect(page).to have_content 'タスク 詳細'
      expect(page).to have_content 'hoge_task'
      expect(Task.all.length).to eq 1
    end
  end

  describe 'Deleting a task successfully' do
    before do
      @tasks = create(:task, name: 'sample_task')
      visit "/tasks"
    end
    it 'successfully update a task' do
      expect(Task.all.length).to eq 1
      click_link('削除')
      expect(page).to have_content 'タスクが正常に削除されました。'
      expect(page).to have_content 'タスク 一覧'
      expect(page).not_to have_content 'hoge_task'
      expect(Task.all.length).to eq 0
    end
  end

  describe 'I18n' do
    context 'Specify nothing' do
      it 'shows Default(Japanese) pages' do
        visit '/'
        expect(page).to have_content 'タスク 一覧'
      end
    end

    context 'Specify Japanese locale' do
      it 'shows Japanese pages' do
        visit '/?locale=ja'
        expect(page).to have_content 'タスク 一覧'
      end
    end

    context 'Specify English locale' do
      it 'shows English pages' do
        visit '/?locale=en'
        expect(page).to have_content 'task'
      end
    end

    context 'Moving another page from English page' do
      it 'takes over the locale setting and shows English pages' do
        visit '/?locale=en'
        expect(page).to have_content 'task list'
        click_link('add')
        expect(current_url).to include 'locale=en'
        expect(page).to have_content 'task new'
      end
    end
  end
end
