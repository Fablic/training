# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(255) }
    it { is_expected.to validate_presence_of(:priority) }
    it { is_expected.to validate_presence_of(:status) }
  end

  describe 'enums' do
    it {
      is_expected.to define_enum_for(:priority).with_values(
        low: 0,    # 低
        normal: 1, # 普通
        high: 2    # 高
      ).with_prefix
    }

    it {
      is_expected.to define_enum_for(:status).with_values(
        untouched: 0, # 未着手
        touched: 1,   # 着手中
        completed: 2  # 完了
      ).with_prefix
    }
  end

  describe 'scope' do
    describe 'sort_by_keyword' do
      let!(:first_task) { create(:task, name: 'ううう') }
      let!(:second_task) { create(:task, name: 'あああ') }
      let!(:third_task) { create(:task, name: 'いいい') }

      subject { Task.sort_by_keyword(sort) }

      context 'when sort type is id_asc' do
        let(:sort) { 'id_asc' }

        it 'sort by specified sort type' do
          is_expected.to eq [first_task, second_task, third_task]
        end
      end

      context 'when sort type is id_desc' do
        let(:sort) { 'id_desc' }

        it 'sort by specified sort type' do
          is_expected.to eq [third_task, second_task, first_task]
        end
      end
    end

    describe 'search_keyword' do
      let!(:first_task) { create(:task, name: 'タスク', explanation: '説明文') }
      let!(:second_task) { create(:task, name: 'ラスク', explanation: 'タスク') }
      let!(:third_task) { create(:task, name: 'リスク', explanation: 'にゃんこ') }

      subject { Task.search_keyword(keyword) }

      context 'when exist search_keyword' do
        let(:keyword) { 'タスク' }

        it 'search from name or explanation' do
          is_expected.to eq [first_task, second_task]
        end
      end
    end

    describe 'search_status' do
      let!(:first_task) { create(:task, status: 'untouched') }
      let!(:second_task) { create(:task, status: 'touched') }
      let!(:third_task) { create(:task, status: 'untouched') }

      subject { Task.search_status(status) }

      context 'when exist search_status' do
        let(:status) { 'untouched' }

        it 'search from specified status' do
          is_expected.to eq [first_task, third_task]
        end
      end
    end
  end
end
