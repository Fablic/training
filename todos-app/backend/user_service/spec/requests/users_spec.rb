# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/users', type: :request do
  let(:valid_attributes) do
    { email: 'example@gmail.com', username: 'username', role: 'admin', password: 'password' }
  end

  let(:invalid_attributes) do
    { email: 'invalid email' }
  end

  let(:valid_user_headers) do
    mock_token = JWT.encode({ user_id: 1, role: 'user' }, Rails.application.secrets.jwt_secret_key, 'HS256')
    { Authorization: "Bearer #{mock_token}" }
  end

  let(:valid_admin_headers) do
    mock_token = JWT.encode({ user_id: 1, role: 'admin' }, Rails.application.secrets.jwt_secret_key, 'HS256')
    { Authorization: "Bearer #{mock_token}" }
  end

  describe 'GET /users' do
    context 'when requested by admin' do
      it 'renders a successful response' do
        create(:user)
        get users_url, headers: valid_admin_headers, as: :json
        expect(response).to be_successful
      end
    end

    context 'when requested by user' do
      it 'renders unauthorized' do
        create(:user)
        get users_url, headers: valid_user_headers, as: :json
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'GET /users/:id' do
    context 'when requested by admin' do
      it 'renders a successful response' do
        user = create(:user)
        get user_url(user), headers: valid_admin_headers, as: :json
        expect(response).to be_successful
      end
    end

    context 'when requested by user' do
      it 'renders unauthorized' do
        user = create(:user)
        get user_url(user), headers: valid_user_headers, as: :json
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'POST /users' do
    context 'with valid parameters' do
      it 'creates a new User' do
        expect do
          post users_url, params: { user: valid_attributes }, as: :json
        end.to change(User, :count).by(1)
      end

      it 'renders a JSON response with the new user' do
        post users_url, params: { user: valid_attributes }, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end

      it 'contains JWT' do
        post users_url, params: { user: valid_attributes }, as: :json
        expect(JSON.parse(response.body)).to include('token')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new User' do
        expect do
          post users_url,
               params: { user: invalid_attributes }, as: :json
        end.to change(User, :count).by(0)
      end

      it 'renders a JSON response with errors for the new user' do
        post users_url,
             params: { user: invalid_attributes }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT/PATCH /users' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { role: 'admin' }
      end

      context 'when requested by admin' do
        it 'updates the requested user' do
          user = create(:user)
          patch user_url(user),
                params: { user: new_attributes }, headers: valid_admin_headers, as: :json
          user.reload
          expect(user.role).to eq(new_attributes[:role])
        end

        it 'renders a JSON response with the user' do
          user = create(:user)
          patch user_url(user),
                params: { user: new_attributes }, headers: valid_admin_headers, as: :json
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to match(a_string_including('application/json'))
        end
      end

      context 'when requested by user' do
        it 'renders unauthorized' do
          user = create(:user)
          patch user_url(user),
                params: { user: new_attributes }, headers: valid_user_headers, as: :json
          expect(response.status).to eq(401)
        end
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the user' do
        user = create(:user)
        patch user_url(user),
              params: { user: { role: 3 } }, headers: valid_admin_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'when requested by admin' do
      it 'destroys the requested user' do
        user = create(:user)
        expect do
          delete user_url(user), headers: valid_admin_headers, as: :json
        end.to change(User, :count).by(-1)
      end
    end

    context 'when requested by user' do
      it 'renders unauthorized' do
        user = create(:user)
        delete user_url(user), headers: valid_user_headers, as: :json
        expect(response.status).to eq(401)
      end
    end
  end
end
