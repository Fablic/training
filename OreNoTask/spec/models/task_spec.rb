# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Taskモデルのテスト', type: :model do
  let(:task) { Task.new(name: name, description: description, start_at: start_at, due_date_at: due_date_at) }
  let(:name) { '最初のタスク' }
  let(:description) { '説明文' }
  let(:start_at) { '2021/09/01 10:00' }
  let(:due_date_at) { '2021/09/02 11:00' }

  describe '正常系' do
    context '全項目入力' do
      it '正常' do
        expect(task).to be_valid
      end
    end

    context 'descriptionが空欄' do
      let(:description) { '' }

      it '正常' do
        expect(task).to be_valid
      end
    end
  end

  describe 'バリデーションのテスト' do
    describe 'nameカラム' do
      context '空欄' do
        let(:name) { '' }

        it 'エラー' do
          expect(task.valid?).to eq false
        end
      end

      context '50文字以内' do
        let(:name) { 'a' * 50 }

        it '正常' do
          expect(task.valid?).to eq true
        end
      end

      context '51文字以上' do
        let(:name) { 'a' * 51 }

        it 'エラー' do
          expect(task.valid?).to eq false
        end
      end
    end

    describe 'descriptionカラム' do
      context '2000文字以内' do
        let(:description) { 'a' * 2000 }

        it '正常' do
          expect(task.valid?).to eq true
        end
      end

      context '2000文字以上' do
        let(:description) { 'a' * 2001 }

        it 'エラー' do
          expect(task.valid?).to eq false
        end
      end
    end

    describe 'start_atカラム' do
      context '空欄でないこと' do
        let(:start_at) { '' }

        it 'エラー' do
          expect(task.valid?).to eq false
        end
      end

      context '日付のフォーマットが不正' do
        let(:start_at) { '2021年09ー01 10:00' }

        it 'エラー' do
          expect(task.valid?).to eq false
        end
      end

      context '存在しない日付' do
        let(:start_at) { '2021/02/99 10:00' }

        it 'エラー' do
          expect(task.valid?).to eq false
        end
      end

      context '存在しない時間' do
        let(:start_at) { '2021/09/01 10:99' }

        it 'エラー' do
          expect(task.valid?).to eq false
        end
      end
    end

    describe 'due_date_atカラム' do
      context '空欄でないこと' do
        let(:due_date_at) { '' }

        it 'エラー' do
          expect(task.valid?).to eq false
        end
      end

      context '日付のフォーマットが不正' do
        let(:due_date_at) { '2021年09ー02 11:00' }

        it 'エラー' do
          expect(task.valid?).to eq false
        end
      end

      context '存在しない日付' do
        let(:due_date_at) { '2021/09/99 11:00' }

        it 'エラー' do
          expect(task.valid?).to eq false
        end
      end

      context '存在しない時間' do
        let(:due_date_at) { '2021/09/02 11:99' }

        it 'エラー' do
          expect(task.valid?).to eq false
        end
      end
    end

    describe '複合' do
      context 'start_at > due_date_atでないこと' do
        let(:start_at) { '2021/09/01 10:00' }
        let(:due_date_at) { '2021/08/31 10:00' }

        it 'エラー' do
          expect(task.valid?).to eq false
        end
      end
    end
  end
end
