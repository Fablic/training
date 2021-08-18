# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string(255)      not null
#  name            :string(255)      not null
#  password_digest :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'validation' do
    let!(:existing_user) { create(:user) }

    it 'is invalid without name' do
      user.name = nil
      user.valid?
      expect(user.errors[:name]).to include('を入力してください')
    end

    it 'is invalid without email' do
      user.email = nil
      user.valid?
      expect(user.errors[:email]).to include('を入力してください')
    end

    it 'is invalid with existing email' do
      user.email = User.first.email
      user.valid?
      expect(user.errors[:email]).to include('はすでに存在します')
    end

    it 'is invalid without password' do
      user.password = nil
      user.valid?
      expect(user.errors[:password]).to include('を入力してください')
    end
  end
end
