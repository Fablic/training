# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'storing passwords' do
    before { @new_user = FactoryBot.build(:user) }

    describe 'create' do
      it 'should set new generated salt' do
        @new_user.save
        expect(@new_user.salt.length).to eq 32
        expect(@new_user.salt).to match /\A[0-9a-z]+\z/
      end

      it 'should store streched password' do
        password = 'hogehoge'
        @new_user.password = password
        @new_user.save

        2000.times { password = OpenSSL::Digest.hexdigest('SHA256', "#{password}#{@new_user.salt}") }
        expect(@new_user.password_hash).to eq password
      end
    end

    describe 'update' do
      it 'should store updated streched password' do
        password = 'hogehoge2'
        @new_user.password = password
        @new_user.save

        2000.times { password = OpenSSL::Digest.hexdigest('SHA256', "#{password}#{@new_user.salt}") }
        expect(@new_user.password_hash).to eq password
      end
    end
  end

  context 'password validation' do
    before do
      @password = 'hogehoge'
      @user = FactoryBot.build(:user)
      @user.password = @password
      @user.save
    end

    it 'should validate with applied passwords' do
      expect(@user.validate_password(@password)).to be true
    end

    it 'should return false with wrong passwords' do
      expect(@user.validate_password("#{@password}hoge")).to be false
    end
  end
end
