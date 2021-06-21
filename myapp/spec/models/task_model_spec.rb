# frozen_string_literal: true

require 'rails_helper'
require 'faker'

RSpec.describe Task, type: :model do
  describe 'Validation' do
    subject { build(:task, params) }
    let(:params) { { name: name, desc: desc, status: status, label: label, priority: priority } }
    let(:random_name) { Faker::Alphanumeric.alpha(number: 10) }
    let(:random_desc) { Faker::Alphanumeric.alpha(number: 100) }
    let(:random_desc_200) { Faker::Alphanumeric.alpha(number: 200) }
    let(:random_label) { Faker::Alphanumeric.alpha(number: 10) }
    let(:random_status) { Faker::Number.between(from: 0, to: 2) }
    let(:random_priority) { Faker::Number.between(from: 0, to: 2) }
    let(:random_due_date) { Faker::Time.between(from: DateTime.now, to: DateTime.now + 1) }

    context 'valid all fields' do
      let(:name) { random_name }
      let(:desc) { random_desc }
      let(:status) { random_status }
      let(:label) { random_label }
      let(:priority) { random_priority }
      let(:due_date) { random_due_date }

      it { is_expected.to be_valid }
    end

    context 'invalid name field' do
      let(:name) { nil }
      let(:desc) { random_desc }
      let(:status) { random_status }
      let(:label) { random_label }
      let(:priority) { random_priority }
      let(:due_date) { random_due_date }

      it { is_expected.to_not be_valid }
    end

    context 'invalid desc field' do
      let(:name) { random_name }
      let(:desc) { nil }
      let(:status) { random_status }
      let(:label) { random_label }
      let(:priority) { random_priority }
      let(:due_date) { random_due_date }

      it { is_expected.to_not be_valid }
    end

    context 'invalid status field' do
      let(:name) { random_name }
      let(:desc) { random_desc }
      let(:status) { nil }
      let(:label) { random_label }
      let(:priority) { random_priority }
      let(:due_date) { random_due_date }

      it { is_expected.to_not be_valid }
    end

    context 'invalid label field' do
      let(:name) { random_name }
      let(:desc) { random_desc }
      let(:status) { random_status }
      let(:label) { nil }
      let(:priority) { random_priority }
      let(:due_date) { random_due_date }

      it { is_expected.to_not be_valid }
    end

    context 'invalid priority field' do
      let(:name) { random_name }
      let(:desc) { random_desc }
      let(:status) { random_status }
      let(:label) { random_label }
      let(:priority) { nil }
      let(:due_date) { random_due_date }

      it { is_expected.to_not be_valid }
    end

    context 'invalid description max value' do
      let(:name) { random_name }
      let(:desc) { random_desc_200 }
      let(:status) { random_status }
      let(:label) { random_label }
      let(:priority) { random_priority }

      it { is_expected.to_not be_valid }
    end
  end
end
