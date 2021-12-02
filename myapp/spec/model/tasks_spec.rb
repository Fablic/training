require 'rails_helper'

RSpec.describe 'Tasks Model', type: :model do
  describe 'TaskModelのバリデーションチェック' do
    let(:task) { create(:task) }
    let(:task_valid) { task.valid? }

    context 'nameの値が空欄の時' do
      it 'バリデーションがFalseになる事' do
        task.name = ''
        expect(task_valid).to eq false
      end
    end

    context 'nameの値がnilの時' do
      it 'バリデーションがFalseになる事' do
        task.name = nil
        expect(task_valid).to eq false
      end
    end

    context 'nameの値が256文字以上の時' do
      it 'バリデーションがFalseになる事' do
        task.name = Faker::Lorem.characters(number: 256)
        expect(task_valid).to eq false
      end
    end

    context 'descriptionの値が空欄の時' do
      it 'バリデーションがFalseになる事' do
        task.description = ''
        expect(task_valid).to eq false
      end
    end

    context 'descriptionの値がnilの時' do
      it 'バリデーションがFalseになる事' do
        task.description = nil
        expect(task_valid).to eq false
      end
    end

    context 'descriptionの値が1025文字以上の時' do
      it 'バリデーションがFalseになる事' do
        task.description = Faker::Lorem.characters(number: 1025)
        expect(task_valid).to eq false
      end
    end

    context 'deadline_atの値が空欄の時' do
      it 'バリデーションがFalseになる事' do
        task.deadline_at = ''
        expect(task_valid).to eq false
      end
    end

    context 'deadline_atの値がnilの時' do
      it 'バリデーションがFalseになる事' do
        task.deadline_at = nil
        expect(task_valid).to eq false
      end
    end

    context 'deadline_atの値が過去日時の時' do
      it 'バリデーションがFalseになる事' do
        task.deadline_at = 1.hour.ago
        expect(task_valid).to eq false
      end
    end

    context 'statusの値がnil' do
      it 'バリデーションがFalseになる事' do
        task.status = nil
        expect(task_valid).to eq false
      end
    end

    context 'statusの値が定義されてる値の時' do
      it 'バリデーションがTrueになる事' do
        task.status = Task.statuses.keys.shuffle[0]
        expect(task_valid).to eq true
      end
    end

    context 'statusの値が定義されていない値の時' do
      it '無効となること' do
        expect { task.status = 'not-defined' }.to raise_error(ArgumentError, "'not-defined' is not a valid status")
      end
    end
  end
end
