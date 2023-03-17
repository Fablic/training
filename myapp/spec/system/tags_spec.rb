require 'rails_helper'

RSpec.describe 'Tags', type: :system do
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
      it 'renders tags list page' do
        visit '/'
        expect(page).to have_content 'タグ 一覧'
      end
    end

    describe 'GET /tags' do
      let!(:tag) { create(:tag, user: user, name: 'sample_tag') }

      it 'shows tags list' do
        visit '/tags'
        expect(page).to have_content 'タグ 一覧'
        expect(page).to have_content tag.name
        expect(page.all('table tbody tr').length).to eq 1
      end
    end

    describe 'GET /tags/:id' do
      let(:tag) { create(:tag, user: user, name: 'sample_tag') }

      it 'renders a successful response' do
        visit "/tags/#{tag.id}"
        expect(page).to have_content 'タグ 詳細'
        expect(page).to have_content 'sample_tag'
      end
    end

    describe 'GET /tags/new' do
      it 'renders tags list page' do
        visit '/tags/new'
        expect(page).to have_content 'タグ 新規'
      end
    end

    describe 'GET /tags/:id/edit' do
      let(:tag) { create(:tag, user: user, name: 'sample_tag') }

      it 'renders a successful response' do
        visit "/tags/#{tag.id}/edit"
        expect(page).to have_content 'タグ 編集'
        expect(page).to have_selector 'input[value="sample_tag"]'
      end
    end

    describe 'Creating a new tag' do
      it 'successfully create a tag' do
        visit '/tags'
        click_link('追加')
        fill_in 'tag[name]', with: 'sample_tag'
        find('input[type="submit"]').click
        expect(page).to have_content 'タグが正常に登録されました。'
        expect(page).to have_content 'タグ 詳細'
        expect(page).to have_content 'sample_tag'
      end
    end

    describe 'Updating a tag' do
      let(:tag) { create(:tag, user: user, name: 'sample_tag') }

      it 'successfully update a tag' do
        visit "/tags/#{tag.id}/edit"
        fill_in 'tag[name]', with: 'sample_tag_updated'
        find('input[type="submit"]').click
        expect(page).to have_content 'タグが正常に更新されました。'
        expect(page).to have_content 'タグ 詳細'
        expect(page).to have_content 'sample_tag_updated'
      end
    end

    describe 'Deleting a tag' do
      let!(:tag) { create(:tag, user: user, name: 'sample_tag') }

      it 'successfully update a tag' do
        visit '/tags'
        expect(Tag.all.length).to eq 1
        # see: https://www.rubydoc.info/gems/capybara/Capybara%2FSession:accept_confirm
        page.accept_confirm do
          click_button('削除')
        end
        expect(page).to have_content 'タグが正常に削除されました。'
        expect(page).to have_content 'タグ 一覧'
        expect(page).not_to have_content tag.name
        expect(Tag.all.length).to eq 0
      end
    end
  end

  describe 'Other users operation control' do
    before do
      create(:tag, user: user, name: 'sample_tag')
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
    let!(:tag2) { create(:tag, user: user2, name: 'sample_tag_b') }

    describe 'GET /tags' do
      it 'only shows tags created by myself' do
        visit '/tags'
        expect(page).to have_content 'タグ 一覧'
        expect(page).to have_content 'sample_tag'
        expect(page).not_to have_content 'sample_tag_b'
        expect(page.all('table tbody tr').length).to eq 1
      end
    end

    describe 'GET /tags/:id' do
      it 'blocks other users operation' do
        visit "/tags/#{tag2.id}"
        expect(page).to have_content 'ActiveRecord::RecordNotFound'
      end
    end

    describe 'GET /tags/:id/edit' do
      it 'blocks other users operation' do
        visit "/tags/#{tag2.id}/edit"
        expect(page).to have_content 'ActiveRecord::RecordNotFound'
      end
    end
  end

  describe 'I18n' do
    context 'Specify nothing' do
      it 'shows Default(Japanese) pages' do
        visit '/tags'
        expect(page).to have_content 'タグ 一覧'
      end
    end

    context 'Specify Japanese locale' do
      it 'shows Japanese pages' do
        visit '/tags?locale=ja'
        expect(page).to have_content 'タグ 一覧'
      end
    end

    context 'Specify English locale' do
      it 'shows English pages' do
        visit '/tags?locale=en'
        expect(page).to have_content 'tag'
      end
    end

    context 'Moving another page from English page' do
      it 'takes over the locale setting and shows English pages' do
        visit '/tags?locale=en'
        expect(page).to have_content 'tag list'
        click_link('add')
        expect(current_url).to include 'locale=en'
        expect(page).to have_content 'tag new'
      end
    end
  end

  describe 'Pagenation' do
    context 'the number of tags is 10 or below' do
      before do
        create_list(:tag, 10, user: user)
      end

      it 'shows expected view' do
        visit '/tags'
        expect(page).not_to have_content '次'
        expect(page).not_to have_content '最後'
        expect(page.all('table tbody tr').length).to eq 10
      end
    end

    context 'the number of tags is 11' do
      before do
        create_list(:tag, 11, user: user)
      end

      it 'shows expected view' do
        visit '/tags'
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
  end
end
