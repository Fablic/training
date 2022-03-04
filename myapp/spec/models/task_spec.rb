# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'task_name' do
    context 'タスク名が空の時' do
      let(:task) { build(:task, task_name: '') }

      it 'バリデーションエラーになること' do
        expect(task.valid?).to eq false
      end

      it 'エラーメッセージが表示されること' do
        task.valid?
        expect(task.errors.messages[:task_name]).to include 'を入力してください'
      end
    end

    context 'タスク名がスペースの時' do
      let(:task) { build(:task, task_name: ' ') }

      it 'バリデーションエラーになること' do
        expect(task.valid?).to eq false
      end

      it 'エラーメッセージが表示されること' do
        task.valid?
        expect(task.errors.messages[:task_name]).to include 'を入力してください'
      end
    end

    context 'タスク名がnil時' do
      let(:task) { build(:task, task_name: nil) }

      it 'バリデーションエラーになること' do
        expect(task.valid?).to eq false
      end

      it 'エラーメッセージが表示されること' do
        task.valid?
        expect(task.errors.messages[:task_name]).to include 'を入力してください'
      end
    end
  end

  describe 'description' do
    context '説明が空の時' do
      let(:task) { build(:task, description: '') }

      it 'バリデーションエラーになること' do
        expect(task.valid?).to eq false
      end

      it 'エラーメッセージが表示されること' do
        task.valid?
        expect(task.errors.messages[:description]).to include 'を入力してください'
      end
    end

    context '説明がスペースの時' do
      let(:task) { build(:task, description: ' ') }

      it 'バリデーションエラーになること' do
        expect(task.valid?).to eq false
      end

      it 'エラーメッセージが表示されること' do
        task.valid?
        expect(task.errors.messages[:description]).to include 'を入力してください'
      end
    end

    context '説明がnilの時' do
      let(:task) { build(:task, description: nil) }

      it 'バリデーションエラーになること' do
        expect(task.valid?).to eq false
      end

      it 'エラーメッセージが表示されること' do
        task.valid?
        expect(task.errors.messages[:description]).to include 'を入力してください'
      end
    end
  end
end
