# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Users', type: :request do
  let!(:logined_user) { create(:user) }
  before do
    post '/login', params: { session: { email: logined_user.email, password: logined_user.password } }
  end

  describe 'GET /index' do
    let!(:users) { Kaminari.paginate_array([logined_user] + 10.times.map { create(:user) }).page(page) }

    context 'page:1' do
      let(:page) { 1 }

      it 'renders a successful response' do
        get admin_users_url

        expect(response).to have_http_status(:ok)
        users.each { |user| expect(response.body).to include user.name.to_s }
      end
    end

    context 'page:2' do
      let(:page) { 2 }

      it 'renders a successful response' do
        get admin_users_url + "/?page=#{page}"

        expect(response).to have_http_status(:ok)
        users.each { |user| expect(response.body).to include user.name.to_s }
      end
    end
  end

  describe 'GET /show' do
    let(:user) { create(:user) }

    context 'when user has many tasks' do
      let!(:tasks) { 4.times.map { create(:task, user_id: user.id) } }

      it 'renders a successful response' do
        get admin_user_url(user)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include user.name.to_s
        tasks.each { |task| expect(response.body).to include task.name.to_s }
      end
    end

    context 'when user has no tasks' do
      it 'renders a successful response' do
        get admin_user_url(user)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include user.name.to_s
        expect(response.body).to include "#{user.name}さんのタスクは現在１件もありません〜〜"
      end
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_admin_user_url

      expect(response).to have_http_status(:ok)
      %w[name email password].each { |column| expect(response.body).to include "user[#{column}]" }
    end
  end

  describe 'GET /edit' do
    let(:user) { create(:user) }

    it 'renders a successful response' do
      get edit_admin_user_url(user)

      expect(response).to have_http_status(:ok)
      %w[name email].each { |column| expect(response.body).to include "user[#{column}]" }
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      let(:params) do
        { user: {
          name: 'kuma!',
          email: 'kuma@rakuraku.com',
          password: 'password'
        } }
      end

      it 'creates a new User' do
        expect { post admin_users_url, params: }.to change(User, :count).by(1)
      end

      it 'redirects to the created task' do
        post admin_users_url, params: params

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to admin_users_url
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        { user: {
          name: '',
          email: '',
          password: ''
        } }
      end

      it 'does NOT create a new User' do
        expect { post admin_users_url, params: invalid_params }.to change(User, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post admin_users_url, params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include '3件のエラーが発生しました。'
        expect(response.body).to include 'パスワードを入力してください'
        expect(response.body).to include 'ユーザー名を入力してください'
        expect(response.body).to include 'Eメールを入力してください'
      end
    end
  end

  describe 'PUT /update' do
    context 'with valid parameters' do
      let(:user) { create(:user) }

      let(:update_attributes) do
        {
          name: 'UpdatedUser!',
          email: 'updatedEmail!'
        }
      end

      it 'updates the requested user' do
        put admin_user_url(user), params: { user: update_attributes }

        expect(user.reload).to have_attributes update_attributes
      end

      it 'redirects to the user' do
        put admin_user_url(user), params: { user: update_attributes }

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to admin_users_url
      end
    end

    context 'with invalid parameters' do
      let(:user) { create(:user) }

      let(:invalid_params) do
        { user: {
          name: '',
          email: '',
          password: ''
        } }
      end

      it "renders a successful response (i.e. to display the 'edit' template)" do
        put admin_user_url(user), params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include '2件のエラーが発生しました。'
        expect(response.body).to include 'ユーザー名を入力してください'
        expect(response.body).to include 'Eメールを入力してください'
      end
    end

    context 'can NOT update password without notice' do
      let(:user) { create(:user, password: 'passpass') }

      let(:update_attributes) do
        { password: 'updatePasswword' }
      end

      it 'updates the requested user' do
        put admin_user_url(user), params: { user: update_attributes }

        expect(user.reload).to have_attributes user.attributes
        expect(user.reload).not_to have_attributes update_attributes
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:user) { create(:user) }

    it 'destroys the requested user' do
      expect { delete admin_user_url(user) }.to change(User, :count).by(-1)
    end

    it 'redirects to the users list' do
      delete admin_user_url(user)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to admin_users_url
    end
  end

  describe '#not_found' do
    it 'returns status 404' do
      get '/admin/aqua'

      expect(response).to have_http_status :not_found
      expect(response.body).to include '404なので僕のせいじゃないっす'
      expect(response.body).to include '多分アドレスとか違うっす'
    end

    it 'returns status 404' do
      get '/admin/users/999999'

      expect(response).to have_http_status :not_found
      expect(response.body).to include '404なので僕のせいじゃないっす'
      expect(response.body).to include '多分アドレスとか違うっす'
    end
  end
end
