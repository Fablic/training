# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Taskモデルのテスト', type: :model do
  describe '正常系' do
    context '全項目入力' do
      it '正常' do
        task = Task.new(
          name: '最初のタスク', description: '説明文', start_at: '2021/09/01 10:00', due_date_at: '2021/09/02 11:00',
        )
        expect(task).to be_valid
      end
    end

    context 'descriptionが空欄' do
      it '正常' do
        task = Task.new(
          name: '最初のタスク', description: '', start_at: '2021/09/01 10:00', due_date_at: '2021/09/02 11:00',
        )
        expect(task).to be_valid
      end
    end
  end

  describe 'バリデーションのテスト' do
    describe 'nameカラム' do
      context '空欄' do
        it 'エラー' do
          task = Task.new(
            name: '', description: '説明文', start_at: '2021/09/01 10:00', due_date_at: '2021/09/02 11:00',
          )
          expect(task.valid?).to eq false
        end
      end

      context '50文字以内' do
        it '正常' do
          task = Task.new(
            name: 'a' * 50, description: '説明文', start_at: '2021/09/01 10:00', due_date_at: '2021/09/02 11:00',
          )
          expect(task.valid?).to eq true
        end
      end

      context '51文字以上' do
        it 'エラー' do
          task = Task.new(
            name: 'a' * 51, description: '説明文', start_at: '2021/09/01 10:00', due_date_at: '2021/09/02 11:00',
          )
          expect(task.valid?).to eq false
        end
      end
    end

    describe 'descriptionカラム' do
      context '2000文字以内' do
        it '正常' do
          task = Task.new(
            name: '最初のタスク', description: 'a' * 2000, start_at: '2021/09/01 10:00', due_date_at: '2021/09/02 11:00',
          )
          expect(task.valid?).to eq true
        end
      end

      context '2000文字以上' do
        it 'エラー' do
          task = Task.new(
            name: '最初のタスク', description: 'a' * 2001, start_at: '2021/09/01 10:00', due_date_at: '2021/09/02 11:00',
          )
          expect(task.valid?).to eq false
        end
      end
    end

    describe 'start_atカラム' do
      context '空欄でないこと' do
        it 'エラー' do
          task = Task.new(
            name: '最初のタスク', description: '説明文', start_at: '', due_date_at: '2021/09/02 11:00',
          )
          expect(task.valid?).to eq false
        end
      end

      context '日付のフォーマットが不正' do
        it 'エラー' do
          task = Task.new(
            name: '最初のタスク', description: '説明文', start_at: '2021年09ー01 10:00', due_date_at: '2021/09/02 11:00',
          )
          expect(task.valid?).to eq false
        end
      end

      context '存在しない日付' do
        it 'エラー' do
          task = Task.new(
            name: '最初のタスク', description: '説明文', start_at: '2021/02/99 10:00', due_date_at: '2021/10/02 11:00',
          )
          expect(task.valid?).to eq false
        end
      end

      context '存在しない時間' do
        it 'エラー' do
          task = Task.new(
            name: '最初のタスク', description: '説明文', start_at: '2021/09/01 10:99', due_date_at: '2021/10/02 11:00',
          )
          expect(task.valid?).to eq false
        end
      end
    end

    describe 'due_date_atカラム' do
      context '空欄でないこと' do
        it 'エラー' do
          task = Task.new(
            name: '最初のタスク', description: '説明文', start_at: '2021/09/01 10:00', due_date_at: '',
          )
          expect(task.valid?).to eq false
        end
      end

      context '日付のフォーマットが不正' do
        it 'エラー' do
          task = Task.new(
            name: '最初のタスク', description: '説明文', start_at: '2021/09/01 10:00', due_date_at: '2021年09ー02 11:00',
          )
          expect(task.valid?).to eq false
        end
      end

      context '存在しない日付' do
        it 'エラー' do
          task = Task.new(
            name: '最初のタスク', description: '説明文', start_at: '2021/09/01 10:00', due_date_at: '2021/09/99 11:00',
          )
          expect(task.valid?).to eq false
        end
      end

      context '存在しない時間' do
        it 'エラー' do
          task = Task.new(
            name: '最初のタスク', description: '説明文', start_at: '2021/09/01 10:00', due_date_at: '2021/09/02 11:99',
          )
          expect(task.valid?).to eq false
        end
      end
    end

    describe '複合' do
      context 'start_at > due_date_atでないこと' do
        it 'エラー' do
          task = Task.new(
            name: '最初のタスク', description: '説明文', start_at: '2021/09/01 10:00', due_date_at: '2021/08/31 10:00',
          )
          expect(task.valid?).to eq false
        end
      end
    end
  end
end
