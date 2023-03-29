# == Schema Information
#
# Table name: users
#
#  id                                :bigint           not null, primary key
#  deleted_at                        :datetime
#  email                             :string(255)      not null
#  name                              :string(255)      not null
#  password_digest                   :string(255)      not null
#  role({0: "ordinary", 1: "admin"}) :integer          default(0), not null
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#  index_users_on_name   (name)
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:tasks).dependent(:destroy) }
  end

  describe 'validation' do

    context 'email' do
      let(:user) { FactoryBot.build(:user) }
  
      it { is_expected.to validate_presence_of(:email) }

      it 'with valid parameters' do
        user.email = 'test@rakuten.com'
        expect(user).to be_valid
      end

      it 'with invalid parameters(lack of @)' do
        user.email = 'testrakuten.com'
        expect(user).to be_invalid
      end

      it 'with invalid parameters(invalid space)' do
        user.email = 'test@ rakuten.com'
        expect(user).to be_invalid
      end

      context 'name' do
        it { is_expected.to validate_presence_of(:name) }
        it { is_expected.to validate_length_of(:name).is_at_most(255) }
      end

      context 'password' do
        it { is_expected.to validate_presence_of(:password) }
        it { is_expected.to validate_length_of(:password).is_at_least(8) }
        it { is_expected.not_to validate_length_of(:password).is_at_least(7) }
      end

    end
  end
end
