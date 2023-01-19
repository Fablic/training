require 'rails_helper'

describe TasksFinder do
  let!(:task_1) { create(:task, title: 'task 1') }
  let!(:task_2) { create(:task, :started, title: 'task 2') }
  let!(:task_3) { create(:task, title: 'task 3 new') }
  let(:params) { {} }

  subject { TasksFinder.new(params: params, tasks: Task.all) }

  context 'search with one filed' do
    describe 'filter by title' do
      context 'when search_title is empty' do
        it 'returns all tasks' do
          result = subject.process

          expect(result.size).to eq(3)
        end
      end

      context 'when search_title is present' do
        context 'when corresponding record exists' do
          let(:params) { {search_title: '1'} }
          it 'returns correct tasks' do
            result = subject.process

            expect(result.size).to eq(1)
            expect(result.first.title).to eq('task 1')
          end
        end

        context 'when corresponding record not exists' do
          let(:params) { {search_title: '4'} }
          it 'returns no task' do
            result = subject.process

            expect(result.size).to eq(0)
          end
        end
      end
    end

    describe 'filter by status' do
      context 'when status is empty' do
        it 'returns all tasks' do
          result = subject.process

          expect(result.size).to eq(3)
        end
      end

      context 'when status is present' do
        context 'when corresponding record exists' do
          let(:params) { {status_filter: 'started'} }
          it 'returns correct tasks' do
            result = subject.process

            expect(result.size).to eq(1)
            expect(result.first.title).to eq('task 2')
          end
        end

        context 'when corresponding record not exists' do
          let(:params) { {status_filter: 'completed'} }
          it 'returns no task' do
            result = subject.process

            expect(result.size).to eq(0)
          end
        end
      end
    end

    describe 'filter by tag_name' do
      let(:params) { {tag_name: 'tag1'} }

      context 'when corresponding record exists' do
        before { task_1.tag_list = 'tag1, tag2' }
        it 'returns correct tasks' do
          result = subject.process

          expect(result.size).to eq(1)
          expect(result.first.title).to eq('task 1')
        end
      end

      context 'when corresponding record not exists' do
        it 'returns no task' do
          result = subject.process

          expect(result.size).to eq(0)
        end
      end
    end
  end

  context 'search with multiple fileds' do
    let(:params) { {search_title: 'new', status: 'unstarted'} }
    it 'returns correct tasks' do
      result = subject.process

      expect(result.size).to eq(1)
      expect(result.first.title).to eq('task 3 new')
    end
  end
end
