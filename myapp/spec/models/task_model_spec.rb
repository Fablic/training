# frozen_string_literal: true

require 'rails_helper'
require 'faker'

RSpec.describe Task, type: :model do
  describe 'Validation' do
    subject { build(:task, params) }
    let(:params) { { name: name, desc: desc, status: status, label: label, priority: priority } }
    let(:random_name) { Faker::Alphanumeric.alpha(number: 10) }
    let(:random_desc) { Faker::Alphanumeric.alpha(number: 100) }
    let(:random_desc200) { Faker::Alphanumeric.alpha(number: 200) }
    let(:random_label) { Faker::Alphanumeric.alpha(number: 10) }
    let(:random_status) { Faker::Number.between(from: 0, to: 2) }
    let(:random_priority) { Faker::Number.between(from: 0, to: 2) }

    context 'valid all fields' do
      let(:params) { { name: random_name, desc: random_desc, status: random_status, label: random_label, priority: random_priority } }

      it { is_expected.to be_valid }
    end

    context 'invalid name field' do
      let(:params) { { name: nil, desc: random_desc, status: random_status, label: random_label, priority: random_priority } }

      it { is_expected.to_not be_valid }
    end

    context 'invalid desc field' do
      let(:params) { { name: random_name, desc: nil, status: random_status, label: random_label, priority: random_priority } }

      it { is_expected.to_not be_valid }
    end

    context 'invalid status field' do
      let(:params) { { name: random_name, desc: random_desc, status: nil, label: random_label, priority: random_priority } }

      it { is_expected.to_not be_valid }
    end

    context 'invalid label field' do
      let(:params) { { name: random_name, desc: random_desc, status: random_status, label: nil, priority: random_priority } }

      it { is_expected.to_not be_valid }
    end

    context 'invalid priority field' do
      let(:params) { { name: random_name, desc: random_desc, status: random_status, label: random_label, priority: nil } }

      it { is_expected.to_not be_valid }
    end

    context 'invalid description max value' do
      let(:params) { { name: random_name, desc: random_desc200, status: random_status, label: random_label, priority: nil } }

      it { is_expected.to_not be_valid }
    end
  end
end
