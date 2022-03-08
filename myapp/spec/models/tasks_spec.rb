require 'rails_helper'

RSpec.describe Task, type: :model do
  feature 'バリデーションのテスト' do
    background do
      Capybara.current_driver = Capybara.javascript_driver
      @task1 = FactoryBot.build(:task)
    end
    
    context 'title_タスク名' do
      it '空欄でないこと' do
        @task1.title = ''
        expect(@task1.valid?).to eq(false)
      end
      it '30文字以下であること' do
        @task1.title = '----+----1----+----2----+----31'
        expect(@task1.valid?).to eq(false)
      end
    end

    context 'body' do
      it '空欄でないこと' do
        @task1.body = ''
        expect(@task1.valid?).to eq(false)
      end
    end

    context 'deadline' do
      it '空欄でないこと' do
        @task1.deadline = ''
        expect(@task1.valid?).to eq(false)
      end
      it '今日以降の年月日であること' do
        @task1.deadline = Date.current.yesterday
        expect(@task1.valid?).to eq(false)
      end
    end

    context 'priority' do
      it '空欄でないこと' do
        @task1.priority = ''
        expect(@task1.valid?).to eq(false)
      end
    end

    context 'status' do
      it '空欄でないこと' do
        @task1.status = ''
        expect(@task1.valid?).to eq(false)
      end
    end
  end    

  feature '検索のテスト' do
    background do
      Capybara.current_driver = Capybara.javascript_driver
      @task1 = FactoryBot.create(:task, title: 'task_1', status: 1)
      @task2 = FactoryBot.create(:task, title: 'task_2', status: 1)
      @task3 = FactoryBot.create(:task, title: 'task_3', status: 2)
      @task4 = FactoryBot.create(:task, title: 'task_4', status: 3)
    end

    context 'title="",status="0"(全て)' do
      it 'すべて抽出されること' do
        tasks = Task.search( '', '')
        expect(tasks.count).to eq(4)
      end
    end

    context 'title="_1",status="1"' do
      it 'task1のみが抽出されること' do
        tasks = Task.search( '_1', '1')
        expect(tasks).to include(@task1)
      end
    end

    context 'title="_3",status="0"(全て)' do
      it 'task_3のみが抽出されること' do
        tasks = Task.search( '_3', '0')
        expect(tasks).to include(@task3)
      end
    end

    context 'title="",status="1"' do
      it 'task_1,task_2の2件が抽出されること' do
        tasks = Task.search( '', '1')
        expect(tasks.count).to eq(2)
      end
    end
  end
end
