# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    subject { build(:task, params) }
    let(:params) { { title: title, description: description } }
    let(:random_str) { Faker::Alphanumeric.alpha(number: 10) }
    let(:random_str256) { Faker::Alphanumeric.alpha(number: 256) }
    let(:random_str5001) { Faker::Alphanumeric.alpha(number: 5001) }

    context 'valid' do
      let(:title) { random_str }
      let(:description) { random_str }

      it { is_expected.to be_valid }
    end

    context 'valid description' do
      let(:title) { random_str }
      let(:description) { nil }

      it { is_expected.to be_valid }
    end

    context 'invalid title' do
      let(:title) { nil }
      let(:description) { random_str }

      it { is_expected.to_not be_valid }
    end

    context 'invalid title max value' do
      let(:title) { random_str256 }
      let(:description) { random_str }

      it { is_expected.to_not be_valid }
    end

    context 'invalid description max value' do
      let(:title) { random_str }
      let(:description) { random_str5001 }

      it { is_expected.to_not be_valid }
    end
  end
end
