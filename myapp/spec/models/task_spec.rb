# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'task_name' do
    context 'タスク名が30文字の時' do
      let(:task) { build(:task, task_name: 'a' * 30) }

      it 'バリデーションエラーにならないこと' do
        expect(task.valid?).to eq true
      end
    end

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

    context 'タスク名が31文字以上の時' do
      let(:task) { build(:task, task_name: 'a' * 31) }

      it 'バリデーションエラーになること' do
        expect(task.valid?).to eq false
      end

      it 'エラーメッセージが表示されること' do
        task.valid?
        expect(task.errors.messages[:task_name]).to include 'は30文字以内で入力してください'
      end
    end
  end

  describe 'description' do
    context '説明文が100文字の時' do
      let(:task) { build(:task, description: 'a' * 100) }

      it 'バリデーションエラーにならないこと' do
        expect(task.valid?).to eq true
      end
    end

    context '説明文が空の時' do
      let(:task) { build(:task, description: '') }

      it 'バリデーションエラーになること' do
        expect(task.valid?).to eq false
      end

      it 'エラーメッセージが表示されること' do
        task.valid?
        expect(task.errors.messages[:description]).to include 'を入力してください'
      end
    end

    context '説明文がスペースの時' do
      let(:task) { build(:task, description: ' ') }

      it 'バリデーションエラーになること' do
        expect(task.valid?).to eq false
      end

      it 'エラーメッセージが表示されること' do
        task.valid?
        expect(task.errors.messages[:description]).to include 'を入力してください'
      end
    end

    context '説明文がnilの時' do
      let(:task) { build(:task, description: nil) }

      it 'バリデーションエラーになること' do
        expect(task.valid?).to eq false
      end

      it 'エラーメッセージが表示されること' do
        task.valid?
        expect(task.errors.messages[:description]).to include 'を入力してください'
      end
    end

    context '説明文が101文字以上の時' do
      let(:task) { build(:task, description: 'a' * 101) }

      it 'バリデーションエラーになること' do
        expect(task.valid?).to eq false
      end

      it 'エラーメッセージが表示されること' do
        task.valid?
        expect(task.errors.messages[:description]).to include 'は100文字以内で入力してください'
      end
    end
  end

  describe 'ends_on' do
    context '開始日より前に設定されている時' do
      let(:task) { build(:task, starts_on: '2021/3/7', ends_on: '2021/2/7') }

      it 'バリデーションエラーになること' do
        expect(task.valid?).to eq false
      end

      it 'エラーメッセージが表示されること' do
        task.valid?
        expect(task.errors.messages[:ends_on]).to include 'は開始日より後の日程に設定してください。'
      end
    end

    context '開始日より後に設定されている時' do
      let(:task) { build(:task, starts_on: '2021/3/8', ends_on: '2021/3/9') }

      it 'バリデーションエラーにならないこと' do
        expect(task.valid?).to eq true
      end
    end
  end
end
