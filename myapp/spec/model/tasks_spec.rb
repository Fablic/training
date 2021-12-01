require 'rails_helper'

RSpec.describe 'Tasks Model', type: :model do
  describe 'バリデーションのテスト' do
    let(:task) { create(:task) }
    let(:task_valid) { task.valid? }

    context 'nameカラム' do
      it '空欄でない事' do
        task.name = ''
        expect(task_valid).to eq false
      end

      it 'nilでない事' do
        task.name = nil
        expect(task_valid).to eq false
      end

      it '255文字以下である事' do
        task.name = Faker::Lorem.characters(number: 256)
        expect(task_valid).to eq false
      end
    end

    context 'descriptionカラム' do
      it '空欄でない事' do
        task.description = ''
        expect(task_valid).to eq false
      end

      it 'nilでない事' do
        task.description = nil
        expect(task_valid).to eq false
      end

      it '1024文字以下である事' do
        task.description = Faker::Lorem.characters(number: 1025)
        expect(task_valid).to eq false
      end
    end

    context 'deadline_atカラム' do
      it '空欄でない事' do
        task.deadline_at = ''
        expect(task_valid).to eq false
      end

      it 'nilでない事' do
        task.deadline_at = nil
        expect(task_valid).to eq false
      end

      it '過去日時でない事' do
        task.deadline_at = 1.hour.ago
        expect(task_valid).to eq false
      end
    end
  end
end
