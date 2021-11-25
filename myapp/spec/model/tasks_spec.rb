require 'rails_helper'

RSpec.describe Task, type: :model do
  # 検索
  describe '検索' do
    let(:form) { SearchForm.new(label_ids: [@label1.id]) }
    before do
      @user = FactoryBot.create(:user)
      @label1 = FactoryBot.create(:label)
      @label2 = FactoryBot.create(:label)
      @task = FactoryBot.create(:task, name: 'test', status: 'new', user_id: @user.id)
      @task.labels << @label1
      @task.labels << @label2
      @task.save
    end
    describe '名称検索' do
      context '完全一致' do
        it 'ヒットする' do
          form.name = @task.name
          expect(@user.searched_tasks(form, 1)).to include(@task)
        end
      end
      context '前方一致' do
        it 'ヒットする' do
          form.name = @task.name.slice(0)
          expect(@user.searched_tasks(form, 1)).to include(@task)
        end
      end
      context '後方一致' do
        it 'ヒットする' do
          form.name = @task.name.slice(-1)
          expect(@user.searched_tasks(form, 1)).to include(@task)
        end
      end
      context '部分一致' do
        it 'ヒットする' do
          form.name = @task.name.slice(0, 2)
          expect(@user.searched_tasks(form, 1)).to include(@task)
        end
      end
      context '名称ヒットなし' do
        it 'ヒットしない' do
          form.name = 'sample'
          expect(@user.searched_tasks(form, 1)).to be_empty
        end
      end
    end
    describe '状態検索'  do
      context '状態一致' do
        it 'ヒットする' do
          # form = SearchForm.new(status: 'new', label_ids: [@label1.id])
          form.status = 'new'
          expect(@user.searched_tasks(form, 1)).to include(@task)
        end
      end
    end

    describe '複合条件（名称、状態）' do
      context '名称ヒットあり＆＆状態ヒットなし(and条件確認）' do
        it 'ヒットなし' do
          form.name = @task.name
          form.status = 'complete'
          expect(@user.searched_tasks(form, 1)).to be_empty
        end
      end
    end

    describe 'ラベル検索' do
      context '指定ラベルのタスクがない場合' do
        it 'ヒットなし' do
          form.label_ids = [999]
          expect(@user.searched_tasks(form, 1)).to be_empty
        end
      end
      context '指定ラベルを含む場合（タスクにラベル1とラベル２が設定されている時）（検索ではラベル１のみを選択）' do
        before do
          form.label_ids = [@label1.id]
        end
        it 'タスクがヒットする' do
          expect(@user.searched_tasks(form, 1)).to include(@task)
          expect(@user.searched_tasks(form, 1)[0].labels).to include(@label1)
        end
        it '結果表示には未指定の方のラベル（ラベル２）も含む' do
          expect(@user.searched_tasks(form, 1)[0].labels).to include(@label2)
        end
      end
    end
  end
end
