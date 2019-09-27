# frozen_string_literal: true

describe Task, type: :model do
  describe 'タイトルのバリデーション' do
    before do
      task = FactoryBot.attributes_for(:task)
      @task = Task.new(task)
    end

    context 'タイトルが100文字な場合' do
      it '登録できる' do
        @task.title = 'a' * 100
        expect(@task).to be_valid
      end
    end

    context 'タイトルが101文字な場合' do
      it 'エラーとなる' do
        @task.title = 'a' * 101
        expect(@task).not_to be_valid
      end
    end
  end

  describe '説明のバリデーション' do
    before do
      task = FactoryBot.attributes_for(:task)
      @task = Task.new(task)
    end

    context '説明が1000文字な場合' do
      it '登録できる' do
        @task.description = 'a' * 1000
        expect(@task).to be_valid
      end
    end

    context '説明が1001文字な場合' do
      it 'エラーとなる' do
        @task.description = 'a' * 1001
        expect(@task).not_to be_valid
      end
    end
  end

  describe 'ステータスのバリデーション' do
    before do
      task = FactoryBot.attributes_for(:task)
      @task = Task.new(task)
    end
    
    context '範囲内のステータスの場合' do
      it '0も登録できる' do
        @task.status = Task.statuses[:waiting]
        expect(@task).to be_valid
      end
      it '最大値も登録できる' do
        @task.status = Task.statuses[:completed]
        expect(@task).to be_valid
      end
    end
  end
end
