require 'rails_helper'

RSpec.describe 'Task', type: :model do
  describe 'normal case' do
    context 'all valid parameters' do
      let(:task) {
        Task.new(name: 'sample_task',
                 description: 'hoge fuga',
                 deadline_at: '2023-01-01T00:00')
      }

      it 'has no error' do
        task.valid?
        expect(task.errors.count).to eq 0
      end
    end
  end

  describe 'validation' do
    describe 'name' do
      context 'length is 0' do
        let(:task) {
          Task.new(name: '',
                  description: 'hoge fuga',
                  deadline_at: '2023-01-01T00:00')
        }

        it 'has name validation error' do
          task.valid?
          expect(task.errors.count).to eq 1
          expect(task.errors[:name].present?).to be true
        end
      end

      context 'length is 1' do
        let(:task) {
          Task.new(name: 'a',
                  description: 'hoge fuga',
                  deadline_at: '2023-01-01T00:00')
        }

        it 'has no error' do
          task.valid?
          expect(task.errors.count).to eq 0
        end
      end

      context 'length is 255' do
        let(:task) {
          Task.new(name: 'a' * 255,
                  description: 'hoge fuga',
                  deadline_at: '2023-01-01T00:00')
        }

        it 'has no error' do
          task.valid?
          expect(task.errors.count).to eq 0
        end
      end

      context 'length is 256' do
        let(:task) {
          Task.new(name: 'a' * 256,
                  description: 'hoge fuga',
                  deadline_at: '2023-01-01T00:00')
        }

        it 'has name validation error' do
          task.valid?
          expect(task.errors.count).to eq 1
          expect(task.errors[:name].present?).to be true
        end
      end
    end
  end
end
