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

  describe '.sort_by_keyword' do
    let!(:first_task) { create(:task, name: 'ううう', end_date: '2022/09/15 17:25') }
    let!(:second_task) { create(:task, name: 'あああ', end_date: '2022/09/14 17:25') }
    let!(:third_task) { create(:task, name: 'いいい', end_date: '2022/09/15 18:25') }

    subject { Task.sort_by_keyword(sort) }

    context "When argument 'sort' is created_at_asc" do
      let(:sort) { 'created_at_asc' }

      it 'sort by specified sort type' do
        is_expected.to eq [first_task, second_task, third_task]
      end
    end

    context "When argument 'sort' is created_at_desc" do
      let(:sort) { 'created_at_desc' }

      it 'sort by specified sort type' do
        is_expected.to eq [third_task, second_task, first_task]
      end
    end

    context 'sort type: end_date_asc' do
      let(:sort) { 'end_date_asc' }

      it 'sort by specified sort type' do
        is_expected.to eq [second_task, first_task, third_task]
      end
    end

    context 'sort type: end_date_desc' do
      let(:sort) { 'end_date_desc' }

      it 'sort by specified sort type' do
        is_expected.to eq [third_task, first_task, second_task]
      end
    end
  end

  describe '.search_by_keyword' do
    let!(:first_task) { create(:task, name: 'タスク', explanation: '説明文') }
    let!(:second_task) { create(:task, name: 'ラスク', explanation: 'タスク') }
    let!(:third_task) { create(:task, name: 'リスク', explanation: 'にゃんこ') }

    subject { Task.search_by_keyword(keyword) }

    context "when argument 'search_by_keyword' exists" do
      let(:keyword) { 'タスク' }

      it 'search from name or explanation' do
        is_expected.to eq [first_task, second_task]
      end
    end
  end

  describe '.search_by_status' do
    let!(:first_task) { create(:task, status: 'untouched') }
    let!(:second_task) { create(:task, status: 'touched') }
    let!(:third_task) { create(:task, status: 'untouched') }

    subject { Task.search_by_status(status) }

    context "when argument 'search_by_status' exists" do
      let(:status) { 'untouched' }

      it 'search from specified status' do
        is_expected.to eq [first_task, third_task]
      end
    end
  end

  describe '.check_approved_sort_params' do
    subject { Task.check_approved_sort_params(sort) }

    context "When argument 'sort' does NOT exist in Task::SORT_TYPE keys" do
      let(:sort) { 'name_asc' }

      it 'returns a default sort type' do
        is_expected.to eq 'created_at_asc'
      end
    end

    context "When argument 'sort' is created_at_asc" do
      let(:sort) { 'created_at_asc' }

      it 'returns a specified sort type' do
        is_expected.to eq 'created_at_asc'
      end
    end

    context "When argument 'sort' is created_at_desc" do
      let(:sort) { 'created_at_desc' }

      it 'returns a specified sort type' do
        is_expected.to eq 'created_at_desc'
      end
    end
  end
end
