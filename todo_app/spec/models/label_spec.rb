# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Label, type: :model do
  describe '#valid?' do
    subject { build(:label, params) }
    let(:params) { { name: name } }

    context 'valid' do
      let(:name) { Faker::Alphanumeric.alphanumeric(number: 5) }
      it { is_expected.to be_valid }
    end
    context 'nil name' do
      let(:name) { nil }

      it { is_expected.to_not be_valid }
    end

    context 'more then 10 characters' do
      let(:name) { Faker::Alphanumeric.alphanumeric(number: 11) }

      it { is_expected.to_not be_valid }
    end
  end
end
