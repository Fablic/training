require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe '#new' do
    context 'レスポンスが正常の時' do
      it 'HTTPステータスコードが200、テンプレートが表示されること' do
        get :new
        expect(response).to be_successful
        expect(response).to have_http_status :success
        expect(response).to render_template :new
      end
    end
  end

  describe '#create' do
    context '正常な値' do
      let(:newUser) { { user_name: 'ユーザ名', email: 'test@test.jp', password: 'password1', password_confirmation: 'password1' } }
      it '正常にユーザを作成できること' do
        expect { post :create, params: { user: newUser } }.to change(User, :count).by(1)
      end
      it '新規作成後、タスク一覧ページにリダイレクトされること' do
        post :create, params: { user: newUser }
        expect(response).to redirect_to root_path
      end
    end
    context '不正な値' do
      let(:unjustNewUser) { { user_name: '', email: 'test@test.jp', password: 'password1', password_confirmation: 'password1' } }
      it 'ユーザが作成されないこと' do
        expect { post :create, params: { user: unjustNewUser } }.to change(User, :count).by(0)
      end
      it '新規作成ページが表示されること' do
        post :create, params: { user: unjustNewUser }
        expect(response).to render_template :new
      end
    end
  end
end
