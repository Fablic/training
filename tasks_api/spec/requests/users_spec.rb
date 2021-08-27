# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'POST /users.json' do
    it 'should create new user' do
      post '/users.json', params: { user: { uid: 'user1@example.com', password: 'hogehoge' } }

      expect(User.count).to eq 1
      expect(response.status).to eq 201
    end
  end

  describe 'GET /users.json' do
    it 'should indicate the guest session' do
      get '/users.json'
      ret = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(ret['session_user']).to eq 'guest'
    end

    describe 'after login action' do
      before do
        @user = FactoryBot.build(:user)
        @user.password = 'password'
        @user.save

        post '/users/login.json', params: { uid: @user.uid, password: 'password' }
      end

      it 'should indicate the user session' do
        get '/users.json'
        ret = JSON.parse(response.body)

        expect(response.status).to eq 200
        expect(ret['session_user']).to eq @user.uid
      end

      describe 'after logout action' do
        before do
          post '/users/logout.json'
        end

        it 'should indicate the guest session' do
          get '/users.json'
          ret = JSON.parse(response.body)

          expect(response.status).to eq 200
          expect(ret['session_user']).to eq 'guest'
        end
      end
    end
  end

  describe 'POST /users/login.json' do
    before do
      @user = FactoryBot.build(:user)
      @user.password = 'password'
      @user.save
    end

    it 'should return true for valid credentials' do
      post '/users/login.json', params: { uid: @user.uid, password: 'password' }

      expect(response.status).to eq 200
    end

    it 'should return false for invalid credentials' do
      post '/users/login.json', params: { uid: @user.uid, password: 'wrongpassword' }

      expect(response.status).to eq 404
    end
  end
end
