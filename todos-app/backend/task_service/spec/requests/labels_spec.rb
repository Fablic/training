# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/labels', type: :request do
  let(:valid_attributes) do
    { name: 'label', user_id: 1 }
  end

  let(:invalid_attributes) do
    { name: 'missing user_id' }
  end

  let(:valid_user_headers) do
    mock_token = JWT.encode({ user_id: 1, role: 'user' }, Rails.application.secrets.jwt_secret_key, 'HS256')
    { Authorization: "Bearer #{mock_token}" }
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      create(:label)
      get labels_url, headers: valid_user_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      label = create(:label)
      get label_url(label), headers: valid_user_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Label' do
        expect {
          post labels_url,
               params: { label: valid_attributes }, headers: valid_user_headers, as: :json
        }.to change(Label, :count).by(1)
      end

      it 'renders a JSON response with the new label' do
        post labels_url,
             params: { label: valid_attributes }, headers: valid_user_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Label' do
        expect {
          post labels_url,
               params: { label: invalid_attributes }, as: :json
        }.to change(Label, :count).by(0)
      end

      it 'renders a JSON response with errors for the new label' do
        post labels_url,
             params: { label: invalid_attributes }, headers: valid_user_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { name: 'new_name' }
      end

      it 'updates the requested label' do
        label = create(:label)
        patch label_url(label),
              params: { label: new_attributes }, headers: valid_user_headers, as: :json
        label.reload
        label.name = new_attributes[:name]
      end

      it 'renders a JSON response with the label' do
        label = create(:label)
        patch label_url(label),
              params: { label: new_attributes }, headers: valid_user_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the label' do
        label = create(:label)
        patch label_url(label),
              params: { label: invalid_attributes }, headers: valid_user_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested label' do
      label = create(:label)
      expect {
        delete label_url(label), headers: valid_user_headers, as: :json
      }.to change(Label, :count).by(-1)
    end
  end
end
