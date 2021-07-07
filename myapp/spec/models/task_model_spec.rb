# frozen_string_literal: true

require 'rails_helper'
require 'faker'

RSpec.describe Task, type: :model do
  describe 'Validation' do
    let!(:user) { create(:user) }
    subject { build(:task, params) }
    let(:random_name) { Faker::Alphanumeric.alpha(number: 10) }
    let(:random_desc) { Faker::Alphanumeric.alpha(number: 100) }
    let(:random_desc200) { Faker::Alphanumeric.alpha(number: 200) }
    let(:random_label) { Faker::Alphanumeric.alpha(number: 10) }
    let(:random_status) { Faker::Number.between(from: 0, to: 2) }
    let(:random_priority) { Faker::Number.between(from: 0, to: 2) }
    let(:random_due_date) { Faker::Time.forward(days: 1, period: :evening) }

    let(:params) {
      { name: random_name, desc: random_desc, status: random_status, label: random_label, priority: random_priority, due_date: random_due_date,
        user_id: user.id }
    }

    # TODO: add login validation
    # context 'valid all fields' do
    #   it { is_expected.to be_valid }
    # end

    context 'invalid name field' do
      let(:params) { { name: nil } }
      # it { is_expected.to_not be_valid }
    end

    context 'invalid desc field' do
      let(:params) { { desc: nil } }
      it { is_expected.to_not be_valid }
    end

    context 'invalid status field' do
      let(:params) { { status: nil } }
      it { is_expected.to_not be_valid }
    end

    context 'invalid label field' do
      let(:params) { { label: nil } }
      it { is_expected.to_not be_valid }
    end

    context 'invalid priority field' do
      let(:params) { { priority: nil } }
      it { is_expected.to_not be_valid }
    end

    context 'invalid description max value' do
      let(:params) { { desc: random_desc200 } }
      it { is_expected.to_not be_valid }
    end

    context 'invalid due_date field' do
      let(:params) { { due_date: nil } }
      it { is_expected.to_not be_valid }
    end
  end
end
