require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'GET /login' do
    it 'returns http success' do
      get '/login'

      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /login' do
    let(:user) { create(:user) }

    subject { post '/login', params: }

    context 'valid params' do
      let(:params) do 
        { session: { email: user.email, password: user.password } }
      end

      it 'returns http found' do
        subject

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'invalid email' do
      let(:params) do 
        { session: { email: 'no.user@rakuten.com', password: user.password} }
      end

      it 'returns http success with danger alert' do
        subject
        
        expect(response).to have_http_status(:success)
        expect(flash[:danger])
      end
    end

    context 'invalid password' do
      let(:params) do 
        { session: { email: user.email, password: 'xxxx'} }
      end

      it 'returns http success with danger alert' do
        subject
        
        expect(response).to have_http_status(:success)
        expect(flash[:danger])
      end
    end
  end

  describe 'GET /logout' do
    it 'returns http ok' do
      get '/logout'

      expect(response).to have_http_status(:ok)
    end
  end
end

