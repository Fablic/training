require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:title_max_length) { described_class.validators_on(:title).detect { |v| v.is_a?(ActiveModel::Validations::LengthValidator) }.options[:maximum] }
  let(:description_max_length) { described_class.validators_on(:description).detect { |v| v.is_a?(ActiveModel::Validations::LengthValidator) }.options[:maximum] }
  let(:number_of_multiple_data) { 5 }
  let(:search_title_text) { 'test_title_for_search' }
  let(:search_label_text) { 'sample_label01' }

  shared_examples_for 'バリデーションエラーとなり、想定するメッセージが表示されること' do |column, message|
    it {
      expect(task.valid?).to eq false
      task.valid?
      expect(task.errors.messages[column]).to include message
    }
  end

  describe 'Dependent' do
    let!(:task) { create(:task) }
    let!(:related_user) { task.user_id }

    context 'user_idに紐づくUserデータが削除された場合' do
      it '紐づくTaskデータが削除されること' do
        expect { User.find(related_user).destroy }.to change { Task.count }.by(-1)
        expect { Task.find_by!(user_id: related_user) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'title' do
    let(:task) { build(:task, title: title) }

    context 'タイトルに正常な値が入力されている場合' do
      let(:title) { 'あ' * num }

      context 'タイトルが50文字の場合' do
        let(:num) { title_max_length }

        it 'バリデーションエラーにならないこと' do
          expect(task.valid?).to eq true
        end
      end

      context 'タイトルが51文字以上の場合' do
        let(:num) { title_max_length + 1 }

        it 'バリデーションエラーになること' do
          expect(task.valid?).to eq false
        end

        it 'エラーメッセージが表示されること' do
          task.valid?
          expect(task.errors.messages[:title]).to include 'は50文字以内で入力してください'
        end
      end
    end

    context 'タイトルに正常な値が入力されていない場合' do
      context 'タイトルが空の場合' do
        let(:title) { '' }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :title, I18n.t('errors.messages.blank')
      end

      context 'タイトルが空白の場合' do
        let(:title) { ' ' }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :title, I18n.t('errors.messages.blank')
      end

      context 'タイトルがnilの場合' do
        let(:title) { nil }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :title, I18n.t('errors.messages.blank')
      end
    end
  end

  describe 'description' do
    let(:task) { build(:task, description: description) }

    context '説明に正常な値が入力されている場合' do
      let(:description) { 'あ' * num }

      context '説明が255文字の場合' do
        let(:num) { description_max_length }

        it 'バリデーションエラーにならないこと' do
          expect(task.valid?).to eq true
        end
      end

      context '説明が256文字以上の場合' do
        let(:num) { description_max_length + 1 }

        it 'バリデーションエラーになること' do
          expect(task.valid?).to eq false
        end

        it 'エラーメッセージが表示されること' do
          task.valid?
          expect(task.errors.messages[:description]).to include 'は255文字以内で入力してください'
        end
      end
    end

    context '説明に正常な値が入力されていない場合' do
      context '説明が空の場合' do
        let(:description) { '' }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :description, I18n.t('errors.messages.blank')
      end

      context '説明が空白の場合' do
        let(:description) { ' ' }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :description, I18n.t('errors.messages.blank')
      end

      context '説明がnilの場合' do
        let(:description) { nil }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :description, I18n.t('errors.messages.blank')
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
          expect(task.errors.messages[:termination_at]).to include I18n.t('activerecord.errors.models.task.termination_at_must_be_future')
        end
      end
    end

    context '終了期日に正常な値が入力されていない場合' do
      context '終了期日が空の場合' do
        let(:termination_at) { '' }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :termination_at, I18n.t('errors.messages.blank')
      end

      context '終了期日が空白の場合' do
        let(:termination_at) { ' ' }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :termination_at, I18n.t('errors.messages.blank')
      end

      context '終了期日がnilの場合' do
        let(:termination_at) { nil }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :termination_at, I18n.t('errors.messages.blank')
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

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :priority, I18n.t('activerecord.errors.models.task.invalid_value')
      end
    end

    context '優先度に正常な値が入力されていない場合' do
      context '優先度が空の場合' do
        let(:priority) { '' }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :priority, I18n.t('errors.messages.blank')
      end

      context '優先度が空白の場合' do
        let(:priority) { ' ' }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :priority, I18n.t('errors.messages.blank')
      end

      context '優先度がnilの場合' do
        let(:priority) { nil }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :priority, I18n.t('errors.messages.blank')
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

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :status, I18n.t('activerecord.errors.models.task.invalid_value')
      end
    end

    context 'ステータスに正常な値が入力されていない場合' do
      context 'ステータスが空の場合' do
        let(:status) { '' }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :status, I18n.t('errors.messages.blank')
      end

      context 'ステータスが空白の場合' do
        let(:status) { ' ' }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :status, I18n.t('errors.messages.blank')
      end

      context 'ステータスがnilの場合' do
        let(:status) { nil }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :status, I18n.t('errors.messages.blank')
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
        let!(:task01_for_search) { create(:task, :with_label, data01) }
        let!(:task02_for_search) { create(:task, :with_label, data02) }

        context 'タイトル、ステータス、ラベルIDが指定されている場合' do
          let(:label) { create(:label, name: search_label_text) }
          let(:search_params) do
            {
              title: search_title_text,
              status: Task.statuses[:not_started],
              label_id: task01_for_search.labels[0].id
            }
          end

          let(:data01) do
            {
              title: "#{search_title_text}_01",
              status: Task.statuses[:not_started],
              labels: label
            }
          end

          context '該当するタスクが1件存在する場合' do
            # 検索不一致データ(ステータスが不一致)
            let(:data02) do
              {
                title: "#{search_title_text}_02",
                status: Task.statuses[:done],
                labels: label
              }
            end

            it '検索条件(タイトル：「search_title_text」部分一致, ステータス：「未着手」, ラベル：「sample_label01」)に一致するデータ1件を取得していること' do
              searched_tasks = subject.call
              expect(searched_tasks.size).to eq 1
              expect(searched_tasks[0].title).to eq task01_for_search.title
              expect(searched_tasks[0].status).to eq task01_for_search.status
              expect(searched_tasks[0].labels[0].name).to eq search_label_text
            end
          end

          context '該当するタスクが複数(2件)存在する場合' do
            let(:data02) do
              {
                title: "#{search_title_text}_02",
                status: Task.statuses[:not_started],
                labels: label
              }
            end

            it '検索条件(タイトル：「search_title_text」部分一致, ステータス：「未着手」, ラベル：「sample_label01」})に一致するデータ2件を取得していること' do
              searched_tasks = subject.call
              expect(searched_tasks.size).to eq 2
              expect(searched_tasks[0].title).to eq task01_for_search.title
              expect(searched_tasks[0].status).to eq task01_for_search.status
              expect(searched_tasks[0].labels[0].name).to eq search_label_text
              expect(searched_tasks[1].title).to eq task02_for_search.title
              expect(searched_tasks[1].status).to eq task02_for_search.status
              expect(searched_tasks[1].labels[0].name).to eq search_label_text
            end
          end
        end

        context 'タイトルのみ指定されている場合' do
          let(:search_params) do
            {
              title: search_title_text
            }
          end

          let(:data01) do
            {
              title: "#{search_title_text}_01",
              status: Task.statuses[:not_started]
            }
          end

          context '該当するタスクが1件存在する場合' do
            # 検索不一致データ(タイトルが不一致)
            let(:data02) { {} }

            it '検索条件(タイトル：「search_title_text」部分一致)に一致するデータ1件を取得していること' do
              searched_tasks = subject.call
              expect(searched_tasks.size).to eq 1
              expect(searched_tasks[0].title).to eq task01_for_search.title
              expect(searched_tasks[0].status).to eq task01_for_search.status
            end
          end

          context '該当するタスクが複数(2件)存在する場合' do
            let(:data02) do
              {
                title: "#{search_title_text}_02",
                status: Task.statuses[:done]
              }
            end

            it '検索条件(タイトル：「search_title_text」部分一致)に一致するデータ2件を取得していること' do
              searched_tasks = subject.call
              expect(searched_tasks.size).to eq 2
              expect(searched_tasks[0].title).to eq task01_for_search.title
              expect(searched_tasks[0].status).to eq task01_for_search.status
              expect(searched_tasks[1].title).to eq task02_for_search.title
              expect(searched_tasks[1].status).to eq task02_for_search.status
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
              title: "#{search_title_text}_01",
              status: Task.statuses[:on_progress]
            }
          end

          context '該当するタスクが1件存在する場合' do
            # 検索不一致データ(ステータスが不一致)
            let(:data02) { {} }

            it '検索条件(ステータス：「着手中」)に一致するデータ1件を取得していること' do
              searched_tasks = subject.call
              expect(searched_tasks.size).to eq 1
              expect(searched_tasks[0].title).to eq task01_for_search.title
              expect(searched_tasks[0].status).to eq task01_for_search.status
            end
          end

          context '該当するタスクが複数(2件)存在する場合' do
            let(:data02) do
              {
                title: "#{search_title_text}_02",
                status: Task.statuses[:on_progress]
              }
            end

            it '検索条件(ステータス：「着手中」)に一致するデータ2件を取得していること' do
              searched_tasks = subject.call
              expect(searched_tasks.size).to eq 2
              expect(searched_tasks[0].title).to eq task01_for_search.title
              expect(searched_tasks[0].status).to eq task01_for_search.status
              expect(searched_tasks[1].title).to eq task02_for_search.title
              expect(searched_tasks[1].status).to eq task02_for_search.status
            end
          end
        end

        context 'ラベルIDのみ指定されている場合' do
          let(:label) { create(:label, name: search_label_text) }
          let(:search_params) { { label_id: label.id } }

          context '該当するタスクが1件存在する場合' do
            let(:data01) { { labels: label } }
            let(:data02) { {} }

            it '検索条件(ラベル名：「sample_label01」)に一致するデータ1件を取得していること' do
              searched_tasks = subject.call
              expect(searched_tasks.size).to eq 1
              expect(searched_tasks[0].labels[0].name).to eq search_label_text
            end
          end

          context '該当するタスクが複数(2件)存在する場合' do
            let(:data01) { { labels: label } }
            let(:data02) { { labels: label } }

            it '検索条件(ラベル名：「sample_label01」)に一致するデータ2件を取得していること' do
              searched_tasks = subject.call
              expect(searched_tasks.size).to eq 2
              expect(searched_tasks[0].labels[0].name).to eq search_label_text
              expect(searched_tasks[1].labels[0].name).to eq search_label_text
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
end
