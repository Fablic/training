# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    subject { build(:user, params) }
    let(:params) { { email: email, password: password } }

    context 'valid' do
      let(:email) { Faker::Internet.email }
      let(:password) { Faker::Alphanumeric.alpha(number: 10) }

      it { is_expected.to be_valid }
    end
    context 'when nil email' do
      let(:email) { nil }
      let(:password) { Faker::Alphanumeric.alpha(number: 10) }

      it { is_expected.not_to be_valid }
    end
    context 'when nil password' do
      let(:email) { Faker::Internet.email }
      let(:password) { nil }

      it { is_expected.not_to be_valid }
    end
  end
end
