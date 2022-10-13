# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:tasks).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(255) }
    it { is_expected.to validate_presence_of(:email) }

    context 'uniqueness' do
      subject { create(:user) }
      it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
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

  describe '.find_list_by_admin' do
    let!(:first_user) { create(:user, role: 'admin') }
    let!(:second_user) { create(:user, role: 'ordinary') }
    let!(:third_user) { create(:user, role: 'admin') }

    subject { User.find_list_by_admin }

    it 'search from admin role' do
      is_expected.to eq [first_user, third_user]
    end
  end
end
