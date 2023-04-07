require 'rails_helper'

RSpec.describe 'Labels', type: :request do
  let!(:logined_user) { create(:user, role: 'admin') }
  before do
    post '/login', params: { session: { email: logined_user.email, password: logined_user.password } }
  end

  describe 'GET /index' do
    let!(:labels) { Kaminari.paginate_array(create_list(:label, 11)).page(page) }

    context 'page:1' do
      let(:page) { 1 }

      it 'renders a successful response' do
        get labels_url

        expect(response).to have_http_status(:ok)
        labels.each { |label| expect(response.body).to include label.name.to_s }
      end
    end

    context 'page:2' do
      let(:page) { 2 }

      it 'renders a successful response' do
        get labels_url + "/?page=#{page}"

        expect(response).to have_http_status(:ok)
        labels.each { |label| expect(response.body).to include label.name.to_s }
      end
    end
  end

  describe 'GET /new' do
    context 'when admin user' do
      it 'renders a successful response' do
        get new_label_url

        expect(response).to have_http_status(:ok)
        expect(response.body).to include 'label[name]'
      end
    end

    context 'when ordinary user' do
      let!(:logined_user) { create(:user, role: 'ordinary') }
      before do
        post '/login', params: { session: { email: logined_user.email, password: logined_user.password } }
      end

      it 'renders a successful response' do
        get new_label_url

        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'GET /edit' do
    let(:label) { create(:label) }

    context 'when admin user' do
      it 'renders a successful response' do
        get edit_label_url(label)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include 'label[name]'
      end
    end

    context 'when ordinary user' do
      let!(:logined_user) { create(:user, role: 'ordinary') }
      before do
        post '/login', params: { session: { email: logined_user.email, password: logined_user.password } }
      end

      let(:label) { create(:label) }

      it 'renders a successful response' do
        get edit_label_url(label)

        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      let(:params) do
        { label: { name: 'kuma!' } }
      end

      it 'creates a new label' do
        expect { post labels_url, params: }.to change(Label, :count).by(1)
      end

      it 'redirects to label index' do
        post labels_url, params: params

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to labels_url
      end
    end

    context 'with invalid parameters without name' do
      let(:invalid_params) do
        { label: { name: '' } }
      end

      it 'does NOT create a new label' do
        expect { post labels_url, params: invalid_params }.to change(Label, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post labels_url, params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include '1件のエラーが発生しました。'
        expect(response.body).to include 'ラベル名を入力してください'
      end
    end

    context 'with invalid parameters with 31 over words name' do
      let(:invalid_params) do
        { label: { name: 'a' * 31 } }
      end

      it 'does NOT create a new label' do
        expect { post labels_url, params: invalid_params }.to change(Label, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post labels_url, params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include '1件のエラーが発生しました。'
        expect(response.body).to include 'ラベル名は30文字以内で入力してください'
      end
    end

    context 'when ordinary user' do
      let!(:logined_user) { create(:user, role: 'ordinary') }
      before do
        post '/login', params: { session: { email: logined_user.email, password: logined_user.password } }
      end

      let(:params) do
        { label: { name: 'kuma!' } }
      end

      it 'does NOT create a new label' do
        expect { post labels_url, params: }.to change(Label, :count).by(0)
      end

      it 'renders a successful response' do
        post labels_url, params: params
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'PUT /update' do
    context 'with valid parameters' do
      let(:label) { create(:label) }

      let(:update_attributes) do
        { name: 'Updated label!' }
      end

      it 'updates the requested label' do
        put label_url(label), params: { label: update_attributes }

        expect(label.reload).to have_attributes update_attributes
      end

      it 'redirects to the label' do
        put label_url(label), params: { label: update_attributes }

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to labels_url
      end
    end

    context 'with invalid parameters without name' do
      let(:label) { create(:label) }

      let(:invalid_attributes) do
        { label: { name: '' } }
      end

      it "renders a successful response (i.e. to display the 'edit' template)" do
        put label_url(label), params: invalid_attributes

        expect(response).to have_http_status(:unprocessable_entity)
        expect(label.reload.name).not_to eq invalid_attributes[:label][:name]
        expect(response.body).to include '1件のエラーが発生しました。'
        expect(response.body).to include 'ラベル名を入力してください'
      end
    end

    context 'with invalid parameters with 31 over words name' do
      let(:label) { create(:label) }

      let(:invalid_attributes) do
        { label: { name: 'a' * 31 } }
      end

      it "renders a successful response (i.e. to display the 'edit' template)" do
        put label_url(label), params: invalid_attributes

        expect(response).to have_http_status(:unprocessable_entity)
        expect(label.reload.name).not_to eq invalid_attributes[:label][:name]
        expect(response.body).to include '1件のエラーが発生しました。'
        expect(response.body).to include 'ラベル名は30文字以内で入力してください'
      end
    end

    context 'when ordinary user' do
      let!(:logined_user) { create(:user, role: 'ordinary') }
      before do
        post '/login', params: { session: { email: logined_user.email, password: logined_user.password } }
      end

      let(:label) { create(:label) }

      let(:params) do
        { label: { name: 'kuma!' } }
      end

      it 'renders a successful response' do
        put label_url(label), params: params

        expect(label.reload.name).not_to eq params[:label][:name]
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:label) { create(:label) }

    context 'when admin user' do
      it 'destroys the requested label' do
        expect { delete label_url label }.to change(Label, :count).by(-1)
      end

      it 'redirects to the labels list' do
        delete label_url label

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to labels_url
      end
    end

    context 'when ordinary user' do
      let!(:logined_user) { create(:user, role: 'ordinary') }
      before do
        post '/login', params: { session: { email: logined_user.email, password: logined_user.password } }
      end

      let!(:label) { create(:label) }

      it 'destroys the requested label' do
        expect { delete label_url label }.to change(Label, :count).by(0)
      end

      it 'renders a successful response' do
        delete label_url label

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to labels_url
      end
    end
  end
end
