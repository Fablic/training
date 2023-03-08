require 'rails_helper'

RSpec.describe 'Task', type: :model do
  describe 'normal case' do
    context 'all valid parameters' do
      let(:task) {
        Task.new(name: 'sample_task',
                 description: 'hoge fuga',
                 status: 'unstarted',
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
                   status: 'unstarted',
                   deadline_at: '2023-01-01T00:00')
        }

        it 'has validation error' do
          task.valid?
          expect(task.errors.count).to eq 1
          expect(task.errors[:name].present?).to be true
        end
      end

      context 'length is 1' do
        let(:task) {
          Task.new(name: 'a',
                   description: 'hoge fuga',
                   status: 'unstarted',
                   deadline_at: '2023-01-01T00:00')
        }

        it 'has no error' do
          task.valid?
          expect(task.errors.count).to eq 0
        end
      end

      context 'length is 50' do
        let(:task) {
          Task.new(name: 'a' * 50,
                   description: 'hoge fuga',
                   status: 'unstarted',
                   deadline_at: '2023-01-01T00:00')
        }

        it 'has no error' do
          task.valid?
          expect(task.errors.count).to eq 0
        end
      end

      context 'length is 51' do
        let(:task) {
          Task.new(name: 'a' * 51,
                   description: 'hoge fuga',
                   status: 'unstarted',
                   deadline_at: '2023-01-01T00:00')
        }

        it 'has validation error' do
          task.valid?
          expect(task.errors.count).to eq 1
          expect(task.errors[:name].present?).to be true
        end
      end
    end

    describe 'description' do
      context 'length is 0' do
        let(:task) {
          Task.new(name: 'sample_task',
                   description: '',
                   status: 'unstarted',
                   deadline_at: '2023-01-01T00:00')
        }

        it 'has no error' do
          task.valid?
          expect(task.errors.count).to eq 0
        end
      end

      context 'length is 5000' do
        let(:task) {
          Task.new(name: 'sample_task',
                   description: 'a' * 5000,
                   status: 'unstarted',
                   deadline_at: '2023-01-01T00:00')
        }

        it 'has no error' do
          task.valid?
          expect(task.errors.count).to eq 0
        end
      end

      context 'length is 5001' do
        let(:task) {
          Task.new(name: 'sample_task',
                   description: 'a' * 5001,
                   status: 'unstarted',
                   deadline_at: '2023-01-01T00:00')
        }

        it 'has validation error' do
          task.valid?
          expect(task.errors.count).to eq 1
          expect(task.errors[:description].present?).to be true
        end
      end
    end
  end

  # if 分岐が期待通り動くかのテストをする
  # scope メソッド自体の挙動は rails の責務なのでテストしない
  describe 'scope name_contain' do
    let!(:task) { create(:task, name: 'sample_task') }

    context 'argument is blank' do
      it 'behaves expectedly' do
        expect(Task.name_contain('').length).to eq 1
      end
    end

    context 'argument is nil' do
      it 'behaves expectedly' do
        expect(Task.name_contain(nil).length).to eq 1
      end
    end

    context "argument is one of task's name" do
      it 'behaves expectedly' do
        expect(Task.name_contain(task.name).length).to eq 1
      end
    end

    context "argument is not any of task's name" do
      it 'behaves expectedly' do
        expect(Task.name_contain('fuga').length).to eq 0
      end
    end
  end

  # if 分岐が期待通り動くかのテストをする
  # scope メソッド自体の挙動は rails の責務なのでテストしない
  describe 'scope status' do
    let!(:task) { create(:task, status: 'wip') }

    context 'argument is blank' do
      it 'behaves expectedly' do
        expect(Task.status('').length).to eq 1
      end
    end

    context 'argument is nil' do
      it 'behaves expectedly' do
        expect(Task.status(nil).length).to eq 1
      end
    end

    context "argument is one of task's status" do
      it 'behaves expectedly' do
        expect(Task.status(task.status).length).to eq 1
      end
    end

    context "argument is not any of task's status" do
      it 'behaves expectedly' do
        expect(Task.status('done').length).to eq 0
      end
    end
  end
end
