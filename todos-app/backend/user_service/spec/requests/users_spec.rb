require 'rails_helper'

RSpec.describe '/users', type: :request do
  let(:valid_attributes) do
    { email: 'example@gmail.com', username: 'username', role: 'admin', password: 'password' }
  end

  let(:invalid_attributes) do
    { email: 'invalid email' }
  end

  let(:valid_headers) do
    {}
  end

  describe 'GET /users' do
    it 'renders a successful response' do
      create(:user)
      get users_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe 'GET /users/:id' do
    it 'renders a successful response' do
      user = create(:user)
      get user_url(user), as: :json
      expect(response).to be_successful
    end
  end

  describe 'POST /users' do
    context 'with valid parameters' do
      it 'creates a new User' do
        expect do
          post users_url, params: { user: valid_attributes }, headers: valid_headers, as: :json
        end.to change(User, :count).by(1)
      end

      it 'renders a JSON response with the new user' do
        post users_url,
             params: { user: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
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
             params: { user: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT/PATCH /users' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { username: 'changed_username' }
      end

      it 'updates the requested user' do
        user = create(:user)
        patch user_url(user),
              params: { user: new_attributes }, headers: valid_headers, as: :json
        user.reload
        expect(user.username).to eq(new_attributes[:username])
      end

      it 'renders a JSON response with the user' do
        user = create(:user)
        patch user_url(user),
              params: { user: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the user' do
        user = create(:user)
        patch user_url(user),
              params: { user: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested user' do
      user = create(:user)
      expect do
        delete user_url(user), headers: valid_headers, as: :json
      end.to change(User, :count).by(-1)
    end
  end
end
