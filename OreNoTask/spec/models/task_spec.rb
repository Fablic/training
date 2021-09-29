# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Taskモデルのテスト', type: :model do
  describe '正常系' do
    it '全項目入力' do
      task = Task.new(
        name: '最初のタスク', description: '説明文', start_at: '2021/09/01 10:00', due_date_at: '2021/09/02 11:00',
      )
      expect(task).to be_valid
    end

    it 'descriptionが空欄' do
      task = Task.new(
        name: '最初のタスク', description: '', start_at: '2021/09/01 10:00', due_date_at: '2021/09/02 11:00',
      )
      expect(task).to be_valid
    end
  end

  describe 'バリデーションのテスト' do
    context 'nameカラム' do
      it '空欄でないこと' do
        task = Task.new(
          name: '', description: '説明文', start_at: '2021/09/01 10:00', due_date_at: '2021/09/02 11:00',
        )
        expect(task.valid?).to eq false
      end

      it '50文字以内は正常' do
        task = Task.new(
          name: 'a' * 50, description: '説明文', start_at: '2021/09/01 10:00', due_date_at: '2021/09/02 11:00',
        )
        expect(task.valid?).to eq true
      end

      it '51文字以上はエラー' do
        task = Task.new(
          name: 'a' * 51, description: '説明文', start_at: '2021/09/01 10:00', due_date_at: '2021/09/02 11:00',
        )
        expect(task.valid?).to eq false
      end
    end

    context 'descriptionカラム' do
      it '2000文字以内は正常' do
        task = Task.new(
          name: '最初のタスク', description: 'a' * 2000, start_at: '2021/09/01 10:00', due_date_at: '2021/09/02 11:00',
        )
        expect(task.valid?).to eq true
      end

      it '51文字以上はエラー' do
        task = Task.new(
          name: '最初のタスク', description: 'a' * 2001, start_at: '2021/09/01 10:00', due_date_at: '2021/09/02 11:00',
        )
        expect(task.valid?).to eq false
      end
    end

    context 'start_atカラム' do
      it '空欄でないこと' do
        task = Task.new(
          name: '最初のタスク', description: '説明文', start_at: '', due_date_at: '2021/09/02 11:00',
        )
        expect(task.valid?).to eq false
      end

      it '日付のフォーマットが不正' do
        task = Task.new(
          name: '最初のタスク', description: '説明文', start_at: '2021年09ー01 10:00', due_date_at: '2021/09/02 11:00',
        )
        expect(task.valid?).to eq false
      end

      it '存在しない日付' do
        task = Task.new(
          name: '最初のタスク', description: '説明文', start_at: '2021/02/99 10:00', due_date_at: '2021/10/02 11:00',
        )
        expect(task.valid?).to eq false
      end

      it '存在しない時間' do
        task = Task.new(
          name: '最初のタスク', description: '説明文', start_at: '2021/09/01 10:99', due_date_at: '2021/10/02 11:00',
        )
        expect(task.valid?).to eq false
      end
    end

    context 'due_date_atカラム' do
      it '空欄でないこと' do
        task = Task.new(
          name: '最初のタスク', description: '説明文', start_at: '2021/09/01 10:00', due_date_at: '',
        )
        expect(task.valid?).to eq false
      end

      it '日付のフォーマットが不正' do
        task = Task.new(
          name: '最初のタスク', description: '説明文', start_at: '2021/09/01 10:00', due_date_at: '2021年09ー02 11:00',
        )
        expect(task.valid?).to eq false
      end

      it '存在しない日付' do
        task = Task.new(
          name: '最初のタスク', description: '説明文', start_at: '2021/09/01 10:00', due_date_at: '2021/09/99 11:00',
        )
        expect(task.valid?).to eq false
      end

      it '存在しない時間' do
        task = Task.new(
          name: '最初のタスク', description: '説明文', start_at: '2021/09/01 10:00', due_date_at: '2021/09/02 11:99',
        )
        expect(task.valid?).to eq false
      end
    end

    context '複合' do
      it 'start_at > due_date_atでないこと' do
        task = Task.new(
          name: '最初のタスク', description: '説明文', start_at: '2021/09/01 10:00', due_date_at: '2021/08/31 10:00',
        )
        expect(task.valid?).to eq false
      end
    end
  end
end
