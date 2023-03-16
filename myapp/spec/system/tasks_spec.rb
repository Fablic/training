require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let(:user) {
    create(:user, name: 'taro',
                  email: 'taro@hoge.hoge',
                  password: 'password')
  }

  before do
    driven_by(:remote_chrome)
    login(user.email, user.password)
  end

  describe 'CRUD' do
    describe 'GET /' do
      it 'renders tasks list page' do
        visit '/'
        expect(page).to have_content 'タスク 一覧'
      end
    end

    describe 'GET /tasks' do
      before do
        create(:task, user: user, name: 'sample_task')
        visit '/tasks'
      end

      it 'shows tasks list' do
        expect(page).to have_content 'タスク 一覧'
        expect(page).to have_content 'sample_task'
        expect(page.all('table tbody tr').length).to eq 1
      end
    end

    describe 'GET /tasks/:id' do
      let(:task) { create(:task, user: user, name: 'sample_task') }

      it 'renders a successful response' do
        visit "/tasks/#{task.id}"
        expect(page).to have_content 'タスク 詳細'
        expect(page).to have_content 'sample_task'
      end
    end

    describe 'GET /tasks/new' do
      it 'renders tasks list page' do
        visit '/tasks/new'
        expect(page).to have_content 'タスク 新規'
      end
    end

    describe 'GET /tasks/:id/edit' do
      let(:task) { create(:task, user: user, name: 'sample_task') }

      it 'renders a successful response' do
        visit "/tasks/#{task.id}/edit"
        expect(page).to have_content 'タスク 編集'
        expect(page).to have_selector 'input[value="sample_task"]'
      end
    end

    describe 'Creating a new task' do
      before do
        visit '/tasks'
        click_link('追加')
        fill_in 'task[name]', with: 'sample_task'
        fill_in 'task[description]', with: 'sample description'
        select '完了', from: 'task_status'
        fill_in 'task[deadline_at]', with: Time.zone.local(2023, 2, 3, 12, 34)
        find('input[type="submit"]').click
      end

      it 'successfully create a task' do
        expect(page).to have_content 'タスクが正常に登録されました。'
        expect(page).to have_content 'タスク 詳細'
        expect(page).to have_content 'sample_task'
        expect(page).to have_content 'sample description'
        expect(page).to have_content '完了'
        expect(page).to have_content '2023-02-03 12:34:00 +0900'
      end
    end

    describe 'Updating a task' do
      let(:task) {
        create(:task, user: user,
                      name: 'sample_task',
                      description: 'sample description',
                      status: 'wip',
                      deadline_at: '2023-02-03T12:34')
      }

      before do
        visit "/tasks/#{task.id}/edit"
        fill_in 'task[name]', with: 'sample_task_updated'
        fill_in 'task[description]', with: 'sample description updated'
        select '完了', from: 'task_status'
        fill_in 'task[deadline_at]', with: Time.zone.local(2023, 3, 4, 13, 56)
        find('input[type="submit"]').click
      end

      it 'successfully update a task' do
        expect(page).to have_content 'タスクが正常に更新されました。'
        expect(page).to have_content 'タスク 詳細'
        expect(page).to have_content 'sample_task_updated'
        expect(page).to have_content 'sample description updated'
        expect(page).to have_content '完了'
        expect(page).to have_content '2023-03-04 13:56:00 +0900'
      end
    end

    describe 'Deleting a task' do
      before do
        create(:task, user: user)
        visit '/tasks'
      end

      it 'successfully update a task' do
        expect(Task.all.length).to eq 1
        # see: https://www.rubydoc.info/gems/capybara/Capybara%2FSession:accept_confirm
        page.accept_confirm do
          click_link('削除')
        end
        expect(page).to have_content 'タスクが正常に削除されました。'
        expect(page).to have_content 'タスク 一覧'
        expect(page).not_to have_content 'hoge_task'
        expect(Task.all.length).to eq 0
      end
    end
  end

  describe 'Other users operation control' do
    before do
      create(:task, user: user, name: 'sample_task')
    end

    # see: https://qiita.com/jnchito/items/37fcaf4486c4bdf78802
    around do |example|
      original = Capybara.raise_server_errors
      Capybara.raise_server_errors = false
      example.run
      Capybara.raise_server_errors = original
    end

    let(:user2) {
      create(:user, name: 'jiro',
                    email: 'jiro@hoge.hoge',
                    password: 'password')
    }
    let!(:task2) { create(:task, user: user2, name: 'sample_task_b') }

    describe 'GET /tasks' do
      it 'only shows tasks created by myself' do
        visit '/tasks'
        expect(page).to have_content 'タスク 一覧'
        expect(page).to have_content 'sample_task'
        expect(page).not_to have_content 'sample_task_b'
        expect(page.all('table tbody tr').length).to eq 1
      end
    end

    describe 'GET /tasks/:id' do
      it 'blocks other users operation' do
        visit "/tasks/#{task2.id}"
        expect(page).to have_content 'ActiveRecord::RecordNotFound'
      end
    end

    describe 'GET /tasks/:id/edit' do
      it 'blocks other users operation' do
        visit "/tasks/#{task2.id}/edit"
        expect(page).to have_content 'ActiveRecord::RecordNotFound'
      end
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

  describe 'Sorting by created_at' do
    let!(:task1) { create(:task, user: user, name: 'hoge_task', created_at: Time.current.yesterday) }
    let!(:task2) { create(:task, user: user, name: 'fuga_task', created_at: Time.current) }

    context 'Sorting asc => desc' do
      it 'sorts successfully' do
        visit '/tasks?sort_direction=asc&sort_key=created_at'
        expect(page).to have_content(/#{task1.name}[\s\S]*#{task2.name}/)
        click_link('作成日時')
        expect(page).to have_content(/#{task2.name}[\s\S]*#{task1.name}/)
      end
    end

    context 'Sorting desc => asc' do
      it 'sorts successfully' do
        visit '/tasks?sort_direction=desc&sort_key=created_at'
        expect(page).to have_content(/#{task2.name}[\s\S]*#{task1.name}/)
        click_link('作成日時')
        expect(page).to have_content(/#{task1.name}[\s\S]*#{task2.name}/)
      end
    end
  end

  describe 'Filtering Function' do
    before do
      create(:task, user: user, name: 'hoge_task', status: 'unstarted')
      create(:task, user: user, name: 'fuga_task', status: 'wip')
      create(:task, user: user, name: 'hoge_fuga_task', status: 'done')
      create(:task, user: user, name: 'fizz_task', status: 'done')
      create(:task, user: user, name: 'buzz_task', status: 'done')
    end

    context 'get /tasks page without querry parameters' do
      it 'does not take over the query parameter.' do
        visit '/tasks'
        expect(find('input[id="name"]').value).to eq ''
        expect(find('select[id="status"]').value).to eq ''
        expect(page.all('table tbody tr').length).to eq 5
      end
    end

    context 'get /tasks page with querry parameters' do
      it 'takes over the query parameter and filters tasks expectedly' do
        visit '/tasks?name=fuga&status=done'
        expect(find('input[id="name"]').value).to eq 'fuga'
        expect(find('select[id="status"]').value).to eq 'done'
        expect(page.all('table tbody tr').length).to eq 1
      end
    end

    context 'filtering by name' do
      before do
        visit '/tasks'
        fill_in 'name', with: 'hoge'
        find('input[type="submit"]').click
      end

      it 'takes over the query parameter and filters tasks expectedly' do
        expect(find('input[id="name"]').value).to eq 'hoge'
        expect(find('select[id="status"]').value).to eq ''
        expect(page.all('table tbody tr').length).to eq 2
      end
    end

    context 'filtering by status' do
      before do
        visit '/tasks'
        select '完了', from: 'status'
        find('input[type="submit"]').click
      end

      it 'takes over the query parameter and filters tasks expectedly' do
        expect(find('input[id="name"]').value).to eq ''
        expect(find('select[id="status"]').value).to eq 'done'
        expect(page.all('table tbody tr').length).to eq 3
      end
    end

    context 'filtering by name & status' do
      before do
        visit '/tasks'
        fill_in 'name', with: 'fuga'
        select '完了', from: 'status'
        find('input[type="submit"]').click
      end

      it 'takes over the query parameter and filters tasks expectedly' do
        expect(find('input[id="name"]').value).to eq 'fuga'
        expect(find('select[id="status"]').value).to eq 'done'
        expect(page.all('table tbody tr').length).to eq 1
      end
    end
  end

  describe 'Pagenation' do
    context 'using sorting' do
      before do
        create_list(:task, 10, user: user, name: 'a_sample_task')
        create(:task, user: user, name: 'b_sample_task')
        visit '/tasks'
      end

      it 'shows expected view' do
        expect(page).to have_content '次'
        expect(page).to have_content '最後'
        expect(page).to have_content 'a_sample_task'
        expect(page).not_to have_content 'b_sample_task'
        expect(page.all('.pagination .page-item').length).to eq 4
        expect(page.all('table tbody tr').length).to eq 10

        click_link('2')

        expect(page).to have_content '前'
        expect(page).to have_content '最初'
        expect(page.all('.pagination .page-item').length).to eq 4
        expect(page.all('table tbody tr').length).to eq 1
        expect(page).not_to have_content 'a_sample_task'
        expect(page).to have_content 'b_sample_task'

        click_link('名前') # 名前の昇順で並び替え

        expect(page).to have_content '次'
        expect(page).to have_content '最後'
        expect(page).to have_content 'a_sample_task'
        expect(page).not_to have_content 'b_sample_task'
        expect(page.all('.pagination .page-item').length).to eq 4
        expect(page.all('table tbody tr').length).to eq 10

        click_link('名前') # 名前の降順で並び替え

        expect(page).to have_content '次'
        expect(page).to have_content '最後'
        expect(page).to have_content(/b_sample_task[\s\S]*a_sample_task/)
        expect(page.all('.pagination .page-item').length).to eq 4
        expect(page.all('table tbody tr').length).to eq 10
      end
    end

    context 'the number of tasks is 10 or below' do
      before do
        create_list(:task, 10, user: user)
        visit '/tasks'
      end

      it 'shows expected view' do
        expect(page).not_to have_content '次'
        expect(page).not_to have_content '最後'
        expect(page.all('table tbody tr').length).to eq 10
      end
    end

    context 'the number of tasks is 11' do
      before do
        create_list(:task, 11, user: user)
        visit '/tasks'
      end

      it 'shows expected view' do
        expect(page).to have_content '次'
        expect(page).to have_content '最後'
        expect(page.all('.pagination .page-item').length).to eq 4
        expect(page.all('table tbody tr').length).to eq 10

        click_link('2')

        expect(page).to have_content '前'
        expect(page).to have_content '最初'
        expect(page.all('.pagination .page-item').length).to eq 4
        expect(page.all('table tbody tr').length).to eq 1
      end
    end

    context 'Filtering & the number of tasks is 10 or below' do
      before do
        create_list(:task, 5, user: user, status: 'unstarted')
        create_list(:task, 10, user: user, status: 'wip')
        visit '/tasks'
      end

      it 'shows expected view' do
        expect(page).to have_content '次'
        expect(page).to have_content '最後'
        expect(page.all('.pagination .page-item').length).to eq 4
        expect(page.all('table tbody tr').length).to eq 10

        select '着手中', from: 'status'
        find('input[type="submit"]').click

        expect(page).not_to have_content '次'
        expect(page).not_to have_content '最後'
        expect(page.all('.pagination .page-item').length).to eq 0
        expect(page.all('table tbody tr').length).to eq 10
      end
    end

    context 'Filtering & the number of tasks is 11' do
      before do
        create_list(:task, 10, user: user, status: 'unstarted')
        create_list(:task, 11, user: user, status: 'wip')
        visit '/tasks'
      end

      it 'shows expected view' do
        expect(page).to have_content '次'
        expect(page).to have_content '最後'
        expect(page.all('.pagination .page-item').length).to eq 5
        expect(page.all('table tbody tr').length).to eq 10

        select '着手中', from: 'status'
        find('input[type="submit"]').click

        expect(page).to have_content '次'
        expect(page).to have_content '最後'
        expect(page.all('table tbody tr').length).to eq 10

        click_link('2')

        expect(page).to have_content '前'
        expect(page).to have_content '最初'
        expect(page.all('.pagination .page-item').length).to eq 4
        expect(page.all('table tbody tr').length).to eq 1
      end
    end
  end
end
