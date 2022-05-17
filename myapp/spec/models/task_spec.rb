require 'rails_helper'

RSpec.describe Task, type: :model do
  msg_no_value = I18n.t('errors.messages.blank').freeze
  msg_invalid_value = I18n.t('activerecord.errors.models.task.invalid_value').freeze
  msg_invalid_termination_at = I18n.t('activerecord.errors.models.task.termination_at_must_be_future').freeze
  title_max_length = 50
  description_max_length = 255
  number_of_multiple_data = 5
  search_base_text = 'test_title_for_search'.freeze

  kaminari_data_per_page = 5
  kaminari_link_page = '<span class="page">'.freeze
  kaminari_link_current_page = '<span class="page current">'.freeze
  kaminari_link_previous = I18n.t('views.pagination.previous').freeze
  kaminari_link_next = I18n.t('views.pagination.next').freeze
  kaminari_link_first = I18n.t('views.pagination.first').freeze
  kaminari_link_last = I18n.t('views.pagination.last').freeze

  shared_examples_for 'バリデーションエラーとなり、想定するメッセージが表示されること' do |column, message|
    it {
      expect(task.valid?).to eq false
      task.valid?
      expect(task.errors.messages[column]).to include message
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
          expect(task.errors.messages[:termination_at]).to include msg_invalid_termination_at
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
    let!(:tasks) { create_list(:task, number_of_multiple_data) }

    describe 'all_sort_by' do
      subject { proc { Task.all_sort_by(column, order) } }

      context '終了期日が指定された場合' do
        let(:column) { :termination_at }

        context '昇順が指定された場合' do
          let(:order) { :asc }
          it '終了期日(昇順)で並び替えられた全てのデータを取得していること' do
            before_task = nil
            get_tasks = subject.call

            expect(get_tasks.size).to eq(number_of_multiple_data)
            get_tasks.each do |task|
              expect(task.send(column.to_s)).to be >= before_task.send(column.to_s) if before_task
              before_task = task
            end
          end
        end

        context '降順が指定された場合' do
          let(:order) { :desc }
          it '終了期日(降順)で並び替えられた全てのデータを取得していること' do
            before_task = nil
            get_tasks = subject.call

            expect(get_tasks.size).to eq(number_of_multiple_data)
            get_tasks.each do |task|
              expect(task.send(column.to_s)).to be <= before_task.send(column.to_s) if before_task
              before_task = task
            end
          end
        end
      end
    end

    describe 'search' do
      subject { proc { Task.search(search_params) } }

      context '値が指定されている場合' do
        let!(:for_search_task01) { create(:task, data01) }
        let!(:for_search_task02) { create(:task, data02) }

        context 'タイトル、ステータスが指定されている場合' do
          let(:search_params) do
            {
              title: search_base_text,
              status: Task.statuses[:not_started]
            }
          end

          let(:data01) do
            {
              title: "#{search_base_text}_01",
              status: Task.statuses[:not_started]
            }
          end

          context '該当するタスクが1件存在する場合' do
            # 検索不一致データ(ステータスが不一致)
            let(:data02) do
              {
                title: "#{search_base_text}_02",
                status: Task.statuses[:done]
              }
            end

            it "検索条件(タイトル：「#{search_base_text}」部分一致, ステータス：#{Task.statuses[:not_started]})に一致するデータ1件を取得していること" do
              searched_tasks = subject.call
              expect(searched_tasks.size).to eq 1
              expect(searched_tasks[0].title).to eq for_search_task01.title
              expect(searched_tasks[0].status).to eq for_search_task01.status
            end
          end

          context '該当するタスクが複数(2件)存在する場合' do
            let(:data02) do
              {
                title: "#{search_base_text}_02",
                status: Task.statuses[:not_started]
              }
            end

            it "検索条件(タイトル：「#{search_base_text}」部分一致, ステータス：#{Task.statuses[:not_started]})に一致するデータ2件を取得していること" do
              searched_tasks = subject.call
              expect(searched_tasks.size).to eq 2
              expect(searched_tasks[0].title).to eq for_search_task01.title
              expect(searched_tasks[0].status).to eq for_search_task01.status
              expect(searched_tasks[1].title).to eq for_search_task02.title
              expect(searched_tasks[1].status).to eq for_search_task02.status
            end
          end
        end

        context 'タイトルのみ指定されている場合' do
          let(:search_params) do
            {
              title: search_base_text
            }
          end

          let(:data01) do
            {
              title: "#{search_base_text}_01",
              status: Task.statuses[:not_started]
            }
          end

          context '該当するタスクが1件存在する場合' do
            # 検索不一致データ(タイトルが不一致)
            let(:data02) {}
            it "検索条件(タイトル：「#{search_base_text}」部分一致)に一致するデータ1件を取得していること" do
              searched_tasks = subject.call
              expect(searched_tasks.size).to eq 1
              expect(searched_tasks[0].title).to eq for_search_task01.title
              expect(searched_tasks[0].status).to eq for_search_task01.status
            end
          end

          context '該当するタスクが複数(2件)存在する場合' do
            let(:data02) do
              {
                title: "#{search_base_text}_02",
                status: Task.statuses[:done]
              }
            end

            it "検索条件(タイトル：「#{search_base_text}」部分一致)に一致するデータ2件を取得していること" do
              searched_tasks = subject.call
              expect(searched_tasks.size).to eq 2
              expect(searched_tasks[0].title).to eq for_search_task01.title
              expect(searched_tasks[0].status).to eq for_search_task01.status
              expect(searched_tasks[1].title).to eq for_search_task02.title
              expect(searched_tasks[1].status).to eq for_search_task02.status
            end
          end
        end

        context 'ステータスのみ指定されている場合' do
          let(:search_params) do
            {
              status: Task.statuses[:on_progress]
            }
          end

          let(:data01) do
            {
              title: "#{search_base_text}_01",
              status: Task.statuses[:on_progress]
            }
          end

          context '該当するタスクが1件存在する場合' do
            # 検索不一致データ(ステータスが不一致)
            let(:data02) {}
            it "検索条件(ステータス：#{Task.statuses[:on_progress]})に一致するデータ1件を取得していること" do
              searched_tasks = subject.call
              expect(searched_tasks.size).to eq 1
              expect(searched_tasks[0].title).to eq for_search_task01.title
              expect(searched_tasks[0].status).to eq for_search_task01.status
            end
          end

          context '該当するタスクが複数(2件)存在する場合' do
            let(:data02) do
              {
                title: "#{search_base_text}_02",
                status: Task.statuses[:on_progress]
              }
            end

            it "検索条件(ステータス：#{Task.statuses[:on_progress]})に一致するデータ2件を取得していること" do
              searched_tasks = subject.call
              expect(searched_tasks.size).to eq 2
              expect(searched_tasks[0].title).to eq for_search_task01.title
              expect(searched_tasks[0].status).to eq for_search_task01.status
              expect(searched_tasks[1].title).to eq for_search_task02.title
              expect(searched_tasks[1].status).to eq for_search_task02.status
            end
          end
        end
      end

      context '値が指定されていない場合' do
        let(:search_params) { {} }
        it '検索条件の指定なく、全てのデータを取得していること' do
          searched_tasks = subject.call
          expect(searched_tasks.size).to eq number_of_multiple_data
        end
      end
    end
  end

  describe 'kaminari', type: :request do
    context 'タスクデータが存在する場合' do
      let!(:tasks) { create_list(:task, kaminari_data_per_page + 1) }

      context '最初のページを開いている場合' do
        it "一覧画面に1 ~ #{kaminari_data_per_page}番目のタスクデータ、ページリンク(#{kaminari_link_previous},#{kaminari_link_first}除く)が表示されること" do
          get tasks_path

          expect(response.body).not_to include tasks[0].title.to_s
          expect(response.body).to include tasks[1].title.to_s
          expect(response.body).to include tasks[kaminari_data_per_page - 1].title.to_s

          expect(response.body).to include kaminari_link_page
          expect(response.body).to include kaminari_link_current_page
          expect(response.body).not_to include kaminari_link_previous
          expect(response.body).to include kaminari_link_next
          expect(response.body).not_to include kaminari_link_first
          expect(response.body).to include kaminari_link_last
        end
      end

      context '最後のページを開いている場合' do
        it "一覧画面に#{kaminari_data_per_page + 1}番目のタスクデータ、ページリンク(#{kaminari_link_next},#{kaminari_link_last}除く)が表示されること" do
          get tasks_path, params: { page: 2 }

          expect(response.body).to include tasks[0].title.to_s
          expect(response.body).not_to include tasks[1].title.to_s
          expect(response.body).not_to include tasks[kaminari_data_per_page - 1].title.to_s

          expect(response.body).to include kaminari_link_page
          expect(response.body).to include kaminari_link_current_page
          expect(response.body).to include kaminari_link_previous
          expect(response.body).not_to include kaminari_link_next
          expect(response.body).to include kaminari_link_first
          expect(response.body).not_to include kaminari_link_last
        end
      end
    end

    context 'タスクデータが存在しない場合' do
      let!(:tasks) {}
      
      it '一覧画面にタスクデータ、ページリンクが一切表示されないこと' do
        get tasks_path

        expect(response.body).not_to include kaminari_link_page
        expect(response.body).not_to include kaminari_link_current_page
        expect(response.body).not_to include kaminari_link_previous
        expect(response.body).not_to include kaminari_link_next
        expect(response.body).not_to include kaminari_link_first
        expect(response.body).not_to include kaminari_link_last
      end
    end
  end
end
