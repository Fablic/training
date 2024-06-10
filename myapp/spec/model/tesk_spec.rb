require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'Validations' do
    context 'When using valid data' do
      it 'is valid when title/details is within their maximum length' do
        task = Task.new(title: '全' * 100, details: '角' * 1000, status: :in_progress, priority: :low)
        expect(task).to be_valid
        expect(task.title).to eq('全' * 100)
        expect(task.details).to eq('角' * 1000)
      end

      it 'sets default enums if not provided' do
        task = Task.new(title: 'Valid Title', details: 'Valid details')
        expect(task).to be_valid
        expect(task.status).to eq(:not_started.to_s)
        expect(task.priority).to eq(:middle.to_s)
      end
    end

    context 'When using invalid data' do
      it 'sets errors.messages.blank' do
        task = Task.create(title: ' ', details: 'Valid details', status: nil, priority: nil)
        expect(task).to_not be_valid
        expect(task.errors[:title]).to include(I18n.t('activerecord.errors.messages.blank'))
      end

      it 'sets errors.messages.too_long' do
        task = Task.create(title: 'A' * 101, details: 'B' * 1001, status: :completed, priority: :high)
        expect(task).to_not be_valid
        expect(task.errors[:title]).to include(I18n.t('activerecord.errors.messages.too_long', count: 100))
        expect(task.errors[:details]).to include(I18n.t('activerecord.errors.messages.too_long', count: 1000))
      end
    end
  end

  describe 'Test for Search' do
    before do
      @task1 = Task.create!(title: 'ryu title1', details: 'ryu details1', status: :not_started, created_at: 1.day.ago)
      @task2 = Task.create!(title: 'ryu title2', details: 'ryu details2', status: :in_progress, created_at: 2.days.ago)
      @task3 = Task.create!(title: 'ryu title3', details: 'ryu details3', status: :completed, created_at: Time.now)
    end

    context 'title' do
      it 'lists results by default order (create_at desc)' do
        task_list = Task.default_order
        expect(task_list.count).to eq 3
        expect(task_list[0]).to eq @task3
        expect(task_list[1]).to eq @task1
        expect(task_list[2]).to eq @task2
      end

      it 'search title' do
        task_list = Task.search_title('')
        expect(task_list.count).to eq 3
        expect(task_list[0]).to eq @task1
        expect(task_list[1]).to eq @task2
        expect(task_list[2]).to eq @task3

        task_list = Task.search_title(@task3.title)
        expect(task_list.count).to eq 1
        expect(task_list[0]).to eq @task3

        task_list = Task.search_title('Non title')
        expect(task_list.count).to eq 0
      end

      it 'search status' do
        task_list = Task.search_status(nil)
        expect(task_list.count).to eq 3
        expect(task_list[0]).to eq @task1
        expect(task_list[1]).to eq @task2
        expect(task_list[2]).to eq @task3

        task_list = Task.search_status(@task3.status)
        expect(task_list.count).to eq 1
        expect(task_list[0]).to eq @task3

        task_list = Task.search_status('Non status')
        expect(task_list.count).to eq 0
      end
    end
  end
end
