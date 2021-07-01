# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Task', type: :model do
  describe 'validation' do
    subject { build(:task, params) }
    let!(:user) { create(:admin_user) }
    let!(:normal_user) { create(:normal_user) }
    let(:params) { { title: title, description: description, task_status: task_status, user_id: user_id } }
    let(:random_str) { Faker::Alphanumeric.alpha(number: 10) }

    describe 'valid' do
      context 'valid all property' do
        let(:title) { random_str }
        let(:description) { random_str }
        let(:task_status) { :todo }
        let(:user_id) { user.id }

        it { is_expected.to be_valid }
      end

      context 'valid description' do
        let(:title) { random_str }
        let(:description) { nil }
        let(:task_status) { :todo }
        let(:user_id) { user.id }

        it { is_expected.to be_valid }
      end
    end

    describe 'invalid' do
      context 'invalid title' do
        let(:title) { nil }
        let(:description) { random_str }
        let(:task_status) { :todo }
        let(:user_id) { user.id }

        it { is_expected.to_not be_valid }
      end

      context 'invalid title max value' do
        let(:title) { Faker::Alphanumeric.alpha(number: 256) }
        let(:description) { random_str }
        let(:task_status) { :todo }
        let(:user_id) { user.id }

        it { is_expected.to_not be_valid }
      end

      context 'invalid description max value' do
        let(:title) { random_str }
        let(:description) { Faker::Alphanumeric.alpha(number: 5001) }
        let(:task_status) { :todo }
        let(:user_id) { user.id }

        it { is_expected.to_not be_valid }
      end

      context 'invalid user_id is nil' do
        let(:title) { random_str }
        let(:description) { Faker::Alphanumeric.alpha(number: 10) }
        let(:task_status) { :todo }
        let(:user_id) { nil }

        it { is_expected.to_not be_valid }
      end

      context 'invalid user_id is not found' do
        let(:title) { random_str }
        let(:description) { Faker::Alphanumeric.alpha(number: 10) }
        let(:task_status) { :todo }
        let(:user_id) { 'hoge-hoge-uuid' }

        it { is_expected.to_not be_valid }
      end
    end

    describe 'search' do
      let!(:todo_task) { create(:task, title: 'Javaを勉強する', task_status: :todo, user_id: normal_user.id) }
      let!(:doing_task) { create(:past_task, title: '英語を1時間勉強する', task_status: :doing, user_id: normal_user.id) }
      let!(:done_task) { create(:task, title: '英語を勉強する', task_status: :done, user_id: user.id) }

      subject(:result) { Task.search(keyword, status, user_id, sort_query) }

      context 'search keyword' do
        let(:keyword) { 'Java' }
        let(:status) { nil }
        let(:user_id) { nil }
        let(:sort_query) { nil }

        it { expect(result.length).to eq 1 }
        it { expect(result[0].title).to eq 'Javaを勉強する' }
      end

      context 'search status' do
        let(:keyword) { nil }
        let(:status) { :todo }
        let(:user_id) { nil }
        let(:sort_query) { nil }

        it { expect(result.length).to match 1 }
        it { expect(result[0].title).to match 'Javaを勉強する' }
      end

      context 'search user_id' do
        let(:keyword) { nil }
        let(:status) { nil }
        let(:user_id) { normal_user.id }
        let(:sort_query) { nil }

        it { expect(result.length).to match 2 }
        it { expect(result[0].title).to match 'Javaを勉強する' }
        it { expect(result[1].title).to match '英語を1時間勉強する' }
      end

      context 'search keyword & status' do
        let(:keyword) { '英語' }
        let(:status) { :doing }
        let(:user_id) { nil }
        let(:sort_query) { nil }

        it { expect(result.length).to match 1 }
        it { expect(result[0].title).to match '英語を1時間勉強する' }
      end

      context 'search keyword & status & sort' do
        let(:keyword) { '英語' }
        let(:status) { :doing }
        let(:user_id) { nil }
        let(:sort_query) { { end_at: 'asc' } }

        it { expect(result.length).to eq 1 }
        it { expect(result[0].title).to eq '英語を1時間勉強する' }
      end

      context 'search keyword & status & user_id & sort' do
        let(:keyword) { '英語' }
        let(:status) { :done }
        let(:user_id) { user.id }
        let(:sort_query) { { end_at: 'asc' } }

        it { expect(result.length).to match 1 }
        it { expect(result[0].title).to eq '英語を勉強する' }
      end

      context 'search none' do
        let(:keyword) { nil }
        let(:status) { nil }
        let(:user_id) { nil }
        let(:sort_query) { nil }

        it { expect(result.length).to match 3 }
        it { expect(result[0].title).to match 'Javaを勉強する' }
      end
    end
  end
end
