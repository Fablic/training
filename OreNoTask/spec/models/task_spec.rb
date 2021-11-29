# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Taskモデルのテスト', type: :model do
  let(:task) { Task.new(name: name, description: description, status: status, start_at: start_at, due_date_at: due_date_at) }
  let(:name) { '最初のタスク' }
  let(:description) { '説明文' }
  let(:status) { :not_started }
  let(:start_at) { '2021/09/01 10:00' }
  let(:due_date_at) { '2021/09/02 11:00' }

  describe 'バリデーション' do
    subject { task }

    context '全項目入力' do
      it { is_expected.to be_valid }
    end

    context 'nameカラム' do
      context '空欄' do
        let(:name) { '' }

        it { is_expected.not_to be_valid }
      end

      context '50文字以内' do
        let(:name) { 'a' * 50 }

        it { is_expected.to be_valid }
      end

      context '51文字以上' do
        let(:name) { 'a' * 51 }

        it { is_expected.not_to be_valid }
      end
    end

    context 'descriptionカラム' do
      context '空欄' do
        let(:description) { '' }

        it { is_expected.to be_valid }
      end

      context '2000文字以内' do
        let(:description) { 'a' * 2000 }

        it { is_expected.to be_valid }
      end

      context '2000文字以上' do
        let(:description) { 'a' * 2001 }

        it { is_expected.not_to be_valid }
      end
    end

    context 'statusカラム' do
      context '許容される値 not_started' do
        let(:status) { :not_started }

        it { is_expected.to be_valid }
      end

      context '許容される値 wip' do
        let(:status) { :wip }

        it { is_expected.to be_valid }
      end

      context '許容される値 completed' do
        let(:status) { :completed }

        it { is_expected.to be_valid }
      end

      context '許容されない値' do
        let(:status) { :pending }

        it { is_expected.not_to be_valid }
      end
    end

    context 'start_atカラム' do
      context '空欄でないこと' do
        let(:start_at) { '' }

        it { is_expected.not_to be_valid }
      end

      context '日付のフォーマットが不正' do
        let(:start_at) { '2021年09ー01 10:00' }

        it { is_expected.not_to be_valid }
      end

      context '存在しない日付' do
        let(:start_at) { '2021/02/99 10:00' }

        it { is_expected.not_to be_valid }
      end

      context '存在しない時間' do
        let(:start_at) { '2021/09/01 10:99' }

        it { is_expected.not_to be_valid }
      end
    end

    context 'due_date_atカラム' do
      context '空欄でないこと' do
        let(:due_date_at) { '' }

        it { is_expected.not_to be_valid }
      end

      context '日付のフォーマットが不正' do
        let(:due_date_at) { '2021年09ー02 11:00' }

        it { is_expected.not_to be_valid }
      end

      context '存在しない日付' do
        let(:due_date_at) { '2021/09/99 11:00' }

        it { is_expected.not_to be_valid }
      end

      context '存在しない時間' do
        let(:due_date_at) { '2021/09/02 11:99' }

        it { is_expected.not_to be_valid }
      end
    end

    context '複合' do
      context 'start_at > due_date_atでないこと' do
        let(:start_at) { '2021/09/01 10:00' }
        let(:due_date_at) { '2021/08/31 10:00' }

        it { is_expected.not_to be_valid }
      end
    end
  end
end
