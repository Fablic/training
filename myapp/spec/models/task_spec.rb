require 'rails_helper'

RSpec.describe Task, type: :model do
  msg_no_value = 'を入力してください'.freeze
  msg_invalid_value = 'に不正な値が入力されています'.freeze
  title_max_length = 50
  description_max_length = 255

  shared_examples_for 'バリデーションエラーとなり、想定するメッセージが表示されること' do |column, message|
    it {
      expect(task.valid?).to eq false
      task.valid?
      expect(task.errors.messages[column]).to include message
    }
  end

  shared_examples_for '指定された任意のカラムに基づく並び替え順でデータが取得できていること' do |column, equals|
    it {
      add_days = 0
      tasks.each do |task|
        task.update({ "#{column}": Date.today + add_days })
        add_days += 1
      end

      before_task = nil
      subject.call.each do |task|
        if before_task
          case equals
          when :asc
            expect(task.send(column.to_s)).to be >= before_task.send(column.to_s)
          when :desc
            expect(task.send(column.to_s)).to be <= before_task.send(column.to_s)
          end
        end
        before_task = task
      end
    }
  end

  shared_examples_for '検索条件に一致するデータが取得できていること' do |count, sort_type|
    it {
      num = 0
      tasks.first(2).each do |task|
        task.update_columns(title: search_text, status: num)
        num += 1
      end

      searched_tasks = subject.call
      expect(searched_tasks.size).to eq count

      searched_tasks.each do |task|
        case sort_type
        when :title_and_status
          expect(task.title).to eq search_text
          expect(task.status).to eq Task.statuses.key(0)
        when :title_only
          expect(task.title).to eq search_text
        when :status_only
          expect(task.status).to eq Task.statuses.key(1)
        end
      end
    }
  end

  describe 'title' do
    let(:task) { build(:task, title: title) }

    context 'タイトルに正常な値が入力されている場合' do
      let(:title) { 'あ' * num }

      context "タイトルが#{title_max_length}文字の場合" do
        let(:num) { title_max_length }

        it 'バリデーションエラーにならないこと' do
          expect(task.valid?).to eq true
        end
      end
      context "タイトルが#{title_max_length + 1}文字以上の場合" do
        let(:num) { title_max_length + 1 }

        it 'バリデーションエラーになること' do
          expect(task.valid?).to eq false
        end
        it 'エラーメッセージが表示されること' do
          task.valid?
          expect(task.errors.messages[:title]).to include "は#{title_max_length}文字以内で入力してください"
        end
      end
    end
    context 'タイトルに正常な値が入力されていない場合' do
      context 'タイトルが空の場合' do
        let(:title) { '' }
        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :title, msg_no_value
      end
      context 'タイトルが空白の場合' do
        let(:title) { ' ' }
        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :title, msg_no_value
      end
      context 'タイトルがnilの場合' do
        let(:title) { nil }
        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :title, msg_no_value
      end
    end
  end

  describe 'description' do
    let(:task) { build(:task, description: description) }

    context '説明に正常な値が入力されている場合' do
      let(:description) { 'あ' * num }

      context "説明が#{description_max_length}文字の場合" do
        let(:num) { description_max_length }

        it 'バリデーションエラーにならないこと' do
          expect(task.valid?).to eq true
        end
      end
      context "説明が#{description_max_length + 1}文字以上の場合" do
        let(:num) { description_max_length + 1 }

        it 'バリデーションエラーになること' do
          expect(task.valid?).to eq false
        end
        it 'エラーメッセージが表示されること' do
          task.valid?
          expect(task.errors.messages[:description]).to include "は#{description_max_length}文字以内で入力してください"
        end
      end
    end
    context '説明に正常な値が入力されていない場合' do
      context '説明が空の場合' do
        let(:description) { '' }
        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :description, msg_no_value
      end
      context '説明が空白の場合' do
        let(:description) { ' ' }
        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :description, msg_no_value
      end
      context '説明がnilの場合' do
        let(:description) { nil }
        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :description, msg_no_value
      end
    end
  end

  describe 'termination_at' do
    let(:task) { build(:task, termination_at: termination_at) }

    context '終了期日に正常な値が入力されている場合' do
      context '終了期日が現在日時よりも後の日付である場合' do
        let(:termination_at) { Time.now + 1 }
        it 'バリデーションエラーにならないこと' do
          expect(task.valid?).to eq true
        end
      end
      context '終了期日が現在日時以前の日付である場合' do
        let(:termination_at) { Time.now }

        it 'バリデーションエラーになること' do
          expect(task.valid?).to eq false
        end
        it 'エラーメッセージが表示されること' do
          task.valid?
          expect(task.errors.messages[:termination_at]).to include 'は現在時刻より後の日付を指定してください'
        end
      end
    end
    context '終了期日に正常な値が入力されていない場合' do
      context '終了期日が空の場合' do
        let(:termination_at) { '' }
        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :termination_at, msg_no_value
      end
      context '終了期日が空白の場合' do
        let(:termination_at) { ' ' }
        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :termination_at, msg_no_value
      end
      context '終了期日がnilの場合' do
        let(:termination_at) { nil }
        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :termination_at, msg_no_value
      end
    end
  end

  describe 'priority' do
    let(:task) { build(:task, priority: priority) }

    context '優先度に正常な値が入力されている場合' do
      context 'Enumで定義されている値の場合' do
        let(:priority) { Task.priorities.key(0) }

        it 'バリデーションエラーにならないこと' do
          expect(task.valid?).to eq true
        end
      end
      context 'Enumで定義されていない値の場合' do
        let(:priority) { 'unknown_priority' }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :priority, msg_invalid_value
      end
    end
    context '優先度に正常な値が入力されていない場合' do
      context '優先度が空の場合' do
        let(:priority) { '' }
        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :priority, msg_no_value
      end
      context '優先度が空白の場合' do
        let(:priority) { ' ' }
        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :priority, msg_no_value
      end
      context '優先度がnilの場合' do
        let(:priority) { nil }
        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :priority, msg_no_value
      end
    end
  end

  describe 'status' do
    let(:task) { build(:task, status: status) }
    context 'ステータスに正常な値が入力されている場合' do
      context 'Enumで定義されている値の場合' do
        let(:status) { Task.statuses.key(0) }

        it 'バリデーションエラーにならないこと' do
          expect(task.valid?).to eq true
        end
      end
      context 'Enumで定義されていない値の場合' do
        let(:status) { 'unknown_status' }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :status, msg_invalid_value
      end
    end
    context 'ステータスに正常な値が入力されていない場合' do
      context 'ステータスが空の場合' do
        let(:status) { '' }
        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :status, msg_no_value
      end
      context 'ステータスが空白の場合' do
        let(:status) { ' ' }
        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :status, msg_no_value
      end
      context 'ステータスがnilの場合' do
        let(:status) { nil }
        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :status, msg_no_value
      end
    end
  end

  describe 'scope' do
    let!(:tasks) { create_list(:task, listnum) }
    let(:listnum) { 5 }

    describe 'all_sort_by' do
      subject { proc { Task.all_sort_by(column, order) } }
      context '終了期日が指定された場合' do
        let(:column) { :termination_at }
        context '昇順が指定された場合' do
          let(:order) { :asc }
          it_behaves_like '指定された任意のカラムに基づく並び替え順でデータが取得できていること', :termination_at, :asc
        end
        context '降順が指定された場合' do
          let(:order) { :desc }
          it_behaves_like '指定された任意のカラムに基づく並び替え順でデータが取得できていること', :termination_at, :desc
        end
      end
    end

    describe 'search' do
      subject { proc { Task.search(params) } }
      let(:search_text) { 'test_title_for_search' }

      context 'タイトル、ステータス指定されている場合' do
        let(:params) do
          {
            title: search_text,
            status: Task.statuses[:not_started]
          }
        end
        it_behaves_like '検索条件に一致するデータが取得できていること', 1, :title_and_status
      end
      context 'タイトルのみ指定されている場合' do
        let(:params) do
          {
            title: search_text
          }
        end
        it_behaves_like '検索条件に一致するデータが取得できていること', 2, :title_only
      end
      context 'ステータスのみ指定されている場合' do
        let(:params) do
          {
            status: Task.statuses[:on_progress]
          }
        end
        it_behaves_like '検索条件に一致するデータが取得できていること', 1, :status_only
      end
      context '何も指定されていない場合' do
        let(:params) { {} }
        it_behaves_like '検索条件に一致するデータが取得できていること', 5, :nothing
      end
    end
  end
end
