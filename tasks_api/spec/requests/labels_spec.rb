# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Labels', type: :request do
  describe 'guest session' do
    it 'should get 401' do
      get '/labels.json'
      expect(response.status).to eq 401
    end
  end

  describe 'user session' do
    before do
      @user = FactoryBot.build(:user)
      @user.password = 'password'
      @user.save

      post '/users/login.json', params: { uid: @user.uid, password: 'password' }
    end

    describe 'GET /labels' do
      before do
        @expected = FactoryBot.create_list(:label, 100, user: @user)
        FactoryBot.create_list(:label, 100) # other user's
      end

      it 'should return all labels' do
        get '/labels.json'
        ret = JSON.parse(response.body)

        expect(response.status).to eq 200
        expect(ret).to eq @expected.map(&:value)
      end
    end
  end
end
