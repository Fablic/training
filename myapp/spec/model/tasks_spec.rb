require 'rails_helper'

RSpec.describe 'Tasks Model', type: :model do
  describe 'TaskModelのバリデーションチェック' do
    let(:task) { create(:task) }
    let(:task_valid) { task.valid? }

    describe 'nameカラム' do
      context '空欄の時' do
        it 'バリデーションがFalseになる事' do
          task.name = ''
          expect(task_valid).to eq false
        end
      end

      context 'nilの時' do
        it 'バリデーションがFalseになる事' do
          task.name = nil
          expect(task_valid).to eq false
        end
      end

      context '256文字以上の時' do
        it 'バリデーションがFalseになる事' do
          task.name = Faker::Lorem.characters(number: 256)
          expect(task_valid).to eq false
        end
      end
    end

    describe 'descriptionカラム' do
      context '空欄の時' do
        it 'バリデーションがFalseになる事' do
          task.description = ''
          expect(task_valid).to eq false
        end
      end

      context 'nilの時' do
        it 'バリデーションがFalseになる事' do
          task.description = nil
          expect(task_valid).to eq false
        end
      end

      context '1025文字以上の時' do
        it 'バリデーションがFalseになる事' do
          task.description = Faker::Lorem.characters(number: 1025)
          expect(task_valid).to eq false
        end
      end
    end

    describe 'deadline_atカラム' do
      context '空欄の時' do
        it 'バリデーションがFalseになる事' do
          task.deadline_at = ''
          expect(task_valid).to eq false
        end
      end

      context 'nilの時' do
        it 'バリデーションがFalseになる事' do
          task.deadline_at = nil
          expect(task_valid).to eq false
        end
      end

      context '過去日時の時' do
        it 'バリデーションがFalseになる事' do
          task.deadline_at = 1.hour.ago
          expect(task_valid).to eq false
        end
      end
    end
  end
end
