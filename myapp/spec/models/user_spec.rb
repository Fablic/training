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

  describe 'enums' do
    it {
      is_expected.to define_enum_for(:role).with_values(
        ordinary: 0, # 一般
        admin: 1    # 管理者
      ).with_prefix
    }
  end

  describe 'cnt_admin_user_except_current' do
    let!(:first_user) { create(:user, role: 'admin') }
    let!(:second_user) { create(:user, role: 'ordinary') }
    let!(:third_user) { create(:user, role: 'admin') }
    let!(:forth_user) { create(:user, role: 'admin') }

    subject { User.cnt_admin_user_except_current(first_user.id) }

    it "count admin's record except first user" do
      is_expected.to eq 2
    end
  end
end
