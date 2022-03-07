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
end
