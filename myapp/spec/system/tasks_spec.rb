require 'rails_helper'

describe 'タスク管理機能', type: :system do
  let(:user) { FactoryBot.create(:user, password: 'password') }
  before do
    FactoryBot.create(:maintenance, service_id: 101, maintenance_flg: false)
    login(user, 'password')
  end

  describe '検索エリア' do


    context '条件なし検索' do
      let!(:task_A1) { FactoryBot.create(:task, title: 'titleA1', status: 'not_started', user_id: user.id) }
      let!(:task_A2) { FactoryBot.create(:task, title: 'titleA2', status: 'in_progress', user_id: user.id) }
      let!(:task_B1) { FactoryBot.create(:task, title: 'titleB1', status: 'not_started', user_id: user.id) }
      let!(:task_B2) { FactoryBot.create(:task, title: 'titleB2', status: 'in_progress', user_id: user.id) }
      let(:conditions) { { title: '', status: '' } }

      it '検索結果の件数が一致すること' do
        visit root_path
        fill_in 'title', with: conditions[:title]
        select value = '', from: 'status'
        click_on '検索'
        expect(all('tbody tr').size).to be(4)
      end

      it 'titleA1が表示されること' do
        visit root_path
        fill_in 'title', with: conditions[:title]
        select value = conditions[:status], from: 'status'
        click_on '検索'

        expect(page).to have_content 'titleA1'
      end

      it 'titleA2が表示されること' do
        visit root_path
        fill_in 'title', with: conditions[:title]
        select value = conditions[:status], from: 'status'
        click_on '検索'

        expect(page).to have_content 'titleA2'
      end

      it 'titleB1が表示されること' do
        visit root_path
        fill_in 'title', with: conditions[:title]
        select value = conditions[:status], from: 'status'
        click_on '検索'

        expect(page).to have_content 'titleB1'
      end

      it 'titleB2が表示されること' do
        visit root_path

        fill_in 'title', with: conditions[:title]
        select value = conditions[:status], from: 'status'
        click_on '検索'

        expect(page).to have_content 'titleB2'
      end
    end

    context 'titleのみ指定して検索' do
      let!(:task_A1) { FactoryBot.create(:task, title: 'titleA1', status: 'not_started', user_id: user.id) }
      let!(:task_A2) { FactoryBot.create(:task, title: 'titleA2', status: 'in_progress', user_id: user.id) }
      let!(:task_B1) { FactoryBot.create(:task, title: 'titleB1', status: 'not_started', user_id: user.id) }
      let!(:task_B2) { FactoryBot.create(:task, title: 'titleB2', status: 'in_progress', user_id: user.id) }
      let(:conditions) { { title: 'A' } }

      it '検索結果の件数が一致すること' do
        visit root_path

        fill_in 'title', with: conditions[:title]
        select value = '', from: 'status'
        click_on '検索'

        expect(all('tbody tr').size).to be(2)
      end

      it 'titleA1が表示されること' do
        visit root_path

        fill_in 'title', with: conditions[:title]
        select value = '', from: 'status'
        click_on '検索'

        expect(page).to have_content 'titleA1'
      end

      it 'titleA2が表示されること' do
        visit root_path

        fill_in 'title', with: conditions[:title]
        select value = '', from: 'status'
        click_on '検索'

        expect(page).to have_content 'titleA2'
      end

      it 'titleB1が表示されないこと' do
        visit root_path

        fill_in 'title', with: conditions[:title]
        select value = '', from: 'status'
        click_on '検索'

        expect(page).not_to have_content 'titleB1'
      end

      it 'titleB2が表示されないこと' do
        visit root_path

        fill_in 'title', with: conditions[:title]
        select value = '', from: 'status'
        click_on '検索'

        expect(page).not_to have_content 'titleB2'
      end
    end

    context 'statusのみ指定して検索' do
      let!(:task_A1) { FactoryBot.create(:task, title: 'titleA1', status: 'not_started', user_id: user.id) }
      let!(:task_A2) { FactoryBot.create(:task, title: 'titleA2', status: 'in_progress', user_id: user.id) }
      let!(:task_B1) { FactoryBot.create(:task, title: 'titleB1', status: 'not_started', user_id: user.id) }
      let!(:task_B2) { FactoryBot.create(:task, title: 'titleB2', status: 'in_progress', user_id: user.id) }
      let(:conditions) { { status: '未着手' } }

      it '検索結果の件数が一致すること' do
        visit root_path

        fill_in 'title', with: ''
        select value = conditions[:status], from: 'status'
        click_on '検索'

        expect(all('tbody tr').size).to be(2)
      end

      it 'titleA1が表示されること' do
        visit root_path

        fill_in 'title', with: ''
        select value = conditions[:status], from: 'status'
        click_on '検索'

        expect(page).to have_content 'titleA1'
      end

      it 'titleA2が表示されないこと' do
        visit root_path

        fill_in 'title', with: ''
        select value = conditions[:status], from: 'status'
        click_on '検索'

        expect(page).not_to have_content 'titleA2'
      end

      it 'titleB1が表示されること' do
        visit root_path

        fill_in 'title', with: ''
        select value = conditions[:status], from: 'status'
         click_on '検索'

        expect(page).to have_content 'titleB1'
      end

      it 'titleB2が表示されないこと' do
        visit root_path

        fill_in 'title', with: ''
        select value = conditions[:status], from: 'status'
        click_on '検索'

        expect(page).not_to have_content 'titleB2'
      end

    end

    context 'title、statusを指定して検索' do
      let!(:task_A1) { FactoryBot.create(:task, title: 'titleA1', status: 'not_started', user_id: user.id) }
      let!(:task_A2) { FactoryBot.create(:task, title: 'titleA2', status: 'in_progress', user_id: user.id) }
      let!(:task_B1) { FactoryBot.create(:task, title: 'titleB1', status: 'not_started', user_id: user.id) }
      let!(:task_B2) { FactoryBot.create(:task, title: 'titleB2', status: 'in_progress', user_id: user.id) }
      let(:conditions) { { title: 'A', status: '未着手' } }

      it '検索結果の件数が一致すること' do
        visit root_path

        fill_in 'title', with: conditions[:title]
        select value = conditions[:status], from: 'status'
        click_on '検索'

        expect(all('tbody tr').size).to be(1)
      end

      it 'titleA1が表示されること' do
        visit root_path

        fill_in 'title', with: conditions[:title]
        select value = conditions[:status], from: 'status'
        click_on '検索'

        expect(page).to have_content 'titleA1'
      end

      it 'titleA2が表示されないこと' do
        visit root_path

        fill_in 'title', with: conditions[:title]
        select value = conditions[:status], from: 'status'
        click_on '検索'

        expect(page).not_to have_content 'titleA2'
      end

      it 'titleB1が表示されないこと' do
        visit root_path

        fill_in 'title', with: conditions[:title]
        select value = conditions[:status], from: 'status'
        click_on '検索'

        expect(page).not_to have_content 'titleB1'
      end

      it 'titleB2が表示されないこと' do
        visit root_path

        fill_in 'title', with: conditions[:title]
        select value = conditions[:status], from: 'status'
        click_on '検索'

        expect(page).not_to have_content 'titleB2'
      end
    end
  end

  describe '一覧表示機能' do
    subject(:visit_tasks) { visit tasks_path }

    describe '表示機能'do
    let!(:maintenance) { FactoryBot.create(:maintenance, service_id: 101, maintenance_flg: false) }

      context 'タスクが1件存在する場合' do
        let!(:task_1) { FactoryBot.create(:task, :with_label, title: '最初のタスク', description: '最初のタスクを実施する', status: 'not_started', user_id: user.id, label_name: 'label1') }

        it 'タスク名が表示される' do
          visit_tasks
          expect(page).to have_content '最初のタスク'
        end

        it '説明が表示される' do
          visit_tasks
          expect(page).to have_content '最初のタスクを実施する'
        end

        it 'ラベルが表示される' do
          visit_tasks
          expect(page).to have_content 'label1'
        end

      end

      context 'タスクが2件(複数)存在する場合' do
        let!(:task_1) { FactoryBot.create(:task, :with_labels, title: '最初のタスク', description: '最初のタスクを実施する', status: 'not_started', user_id: user.id, label_name: 'label1') }
        let!(:task_2) { FactoryBot.create(:task, :with_labels, title: '2つ目のタスク', description: '2つ目のタスクを実施する', status: 'not_started', user_id: user.id, label_name: 'label2') }

        it 'タスク名が表示される' do
          visit_tasks
          expect(page).to have_content '2つ目のタスク'
        end

        it '説明が表示される' do
          visit_tasks
          expect(page).to have_content '2つ目のタスクを実施する'
        end

        it 'ラベルが表示される' do
          visit_tasks
          expect(page).to have_content 'label2'
        end
      end
    end

    describe '画面遷移機能' do
      let!(:task_a) { FactoryBot.create(:task, title: '最初のタスク', description: '最初のタスクを実施する', status: 'not_started', user_id: user.id) }
      context '詳細ボタンをクリックした場合' do
        it '詳細画面へ遷移できる' do
          visit_tasks
          click_link '詳細', match: :first
          expect(page).to have_current_path task_path(task_a)
        end
      end

      context '新規登録ボタンをクリックした場合' do
        it '新規登録画面へ遷移できる' do
          visit_tasks
          click_link '新規登録'
          expect(page).to have_current_path new_task_path
        end
      end
    end

    describe 'ページングエリア' do
      context 'ページングなし' do
        before do
          FactoryBot.create(:task, title: 'title_one', user_id: user.id)
          FactoryBot.create(:task, title: 'title_two', user_id: user.id)
          FactoryBot.create(:task, title: 'title_three', user_id: user.id)
          FactoryBot.create(:task, title: 'title_four', user_id: user.id)
          FactoryBot.create(:task, title: 'title_five', user_id: user.id)
        end

        it 'ページングが表示されないこと ページ番号1' do
          visit root_path
          expect(find('div.pagenation-area')).not_to have_content '1'
        end

        it 'ページングが表示されないこと ページ番号2' do
          visit root_path
          expect(find('div.pagenation-area')).not_to have_content '2'
        end

        it 'ページングが表示されないこと 次ページボタン' do
          visit root_path
          expect(find('div.pagenation-area')).not_to have_content 'Next'
        end

        it 'ページングが表示されないこと 最終ページボタン' do
          visit root_path
          expect(find('div.pagenation-area')).not_to have_content 'Last'
        end
      end

      context 'ページングあり' do
        before do
          FactoryBot.create(:task, title: 'title_one', user_id: user.id)
          FactoryBot.create(:task, title: 'title_two', user_id: user.id)
          FactoryBot.create(:task, title: 'title_three', user_id: user.id)
          FactoryBot.create(:task, title: 'title_four', user_id: user.id)
          FactoryBot.create(:task, title: 'title_five', user_id: user.id)
          FactoryBot.create(:task, title: 'title_six', user_id: user.id)
          FactoryBot.create(:task, title: 'title_seven', user_id: user.id)
          FactoryBot.create(:task, title: 'title_eight', user_id: user.id)
          FactoryBot.create(:task, title: 'title_nine', user_id: user.id)
          FactoryBot.create(:task, title: 'title_ten', user_id: user.id)
          FactoryBot.create(:task, title: 'title_eleven', user_id: user.id)
        end

        it 'ページングが表示されること ページ番号1' do
          visit root_path
          expect(find('div.pagenation-area')).to have_content '1'
        end

        it 'ページングが表示されること ページ番号2' do
          visit root_path
          expect(find('div.pagenation-area')).to have_content '2'
        end

        it 'ページングが表示されること 次ページボタン' do
          visit root_path
          expect(find('div.pagenation-area')).to have_content 'Next'
        end

        it 'ページングが表示されること 最終ページボタン' do
          visit root_path
          expect(find('div.pagenation-area')).to have_content 'Last'
        end

        it 'ページ番号2を押下すると次ページの要素が表示されること' do
          visit root_path
          click_on '2'
          expect(page).to have_content 'title_six'
        end

        it '次ページボタンを押下すると次ページの要素が表示されること' do
          visit root_path
          click_on 'Next'
          expect(page).to have_content 'title_six'
        end

        it '最終ページボタンを押下すると最終ページの要素が表示されること' do
          visit root_path
          click_on 'Last'
          expect(page).to have_content 'title_one'
        end

        it '最初のページボタンを押下すると最初のページの要素が表示されること' do
          visit root_path
          click_on 'Last'
          click_on 'First'
          expect(page).to have_content 'title_eleven'
        end
      end
    end
  end

  describe '詳細表示機能' do
    let!(:task_a) { FactoryBot.create(:task, :with_label, title: '最初のタスク', description: '最初のタスクを実施する', status: 'not_started', user_id: user.id, label_name: 'label1') }
    subject(:visit_task_a) { visit task_path(task_a) }

    describe '表示機能' do
      context 'タスクが存在する場合' do
        it 'タスク名が表示される' do
          visit_task_a
          expect(page).to have_content '最初のタスク'
        end

        it '詳細が表示される' do
          visit_task_a
          expect(page).to have_content '最初のタスクを実施する'
        end

        it 'ラベルが表示される' do
          visit_task_a
          expect(page).to have_content 'label1'
        end

        it 'ステータスが表示される' do
          visit_task_a
          expect(page).to have_content '未着手'
        end

        it 'ユーザIDが表示される' do
          visit_task_a
          expect(page).to have_content '1'
        end
      end
    end

    describe '削除機能' do
      context '削除ボタンをクリックした場合' do
        it 'タスクが1件削除される' do
          visit_task_a
          expect { click_on('削除') }.to change(Task, :count).by(-1)
        end

        it '対象のタスクが無くなる' do
          visit_task_a
          click_on('削除')
          expect(Task.find_by(title: task_a.title)).to be_nil
        end

        it 'Flashメッセージが表示される' do
          visit_task_a
          click_on('削除')
          # Flashメッセージが表示される
          expect(page).to have_selector '.alert-success', text: 'タスク「最初のタスク」を削除しました。'
        end
      end

      context '削除ボタンをクリックした場合' do
        it '編集画面へ遷移できる' do
          visit_task_a
          click_on('削除')
          expect(page).to have_current_path root_path
        end
      end
    end

    describe '画面遷移機能' do
      context '一覧へボタンをクリックした場合' do
        it '一覧画面へ遷移できる' do
          visit_task_a
          click_link '一覧に戻る'
          expect(page).to have_current_path tasks_path
        end
      end

      context '編集ボタンをクリックした場合' do
        it '編集画面へ遷移できる' do
          visit_task_a
          click_link '編集'
          expect(page).to have_current_path edit_task_path(task_a)
        end
      end
    end
  end

  describe '新規登録機能' do

    subject(:visit_new_task){ visit new_task_path }
    subject(:visit_task_a) { visit task_path(task_a) }
    let!(:label_a) { FactoryBot.create(:label, name: '新規タスク 全項目入力 ラベルA') }
    describe '登録機能' do
      context 'タスクの内容を入力した場合' do
        let(:input_values) {
          {
            title: '新規作成のテスト2',
            description: '新規作成のテストを書く2',
            label: label_a.name
          }
        }

        it 'タスクの件数が1件増える' do
          # タスク内容入力
          visit_new_task
          fill_in 'textarea1', with: input_values[:title]
          fill_in 'textarea2', with: input_values[:description]
          select value = input_values[:label], from: 'task[label_ids][]'
          # DBに登録されている
          expect { click_button 'submit' }.to change(Task, :count).by(1)
        end

        it '入力された内容でタスクが作成される' do
          # タスク内容入力
          visit_new_task
          fill_in 'textarea1', with: input_values[:title]
          fill_in 'textarea2', with: input_values[:description]
          select value = input_values[:label], from: 'task[label_ids][]'
          click_button 'submit'
          # 画面で入力された内容でDBに登録されている
          expect(Task.find_by(title: input_values[:title], description: input_values[:description])).to be_present
        end

        it 'Flashメッセージが表示される' do
          # タスク内容入力
          visit_new_task
          fill_in 'textarea1', with: input_values[:title]
          fill_in 'textarea2', with: input_values[:description]
          select value = input_values[:label], from: 'task[label_ids][]'
          # Flashメッセージが表示される
          click_button 'submit'
          expect(page).to have_selector '.alert-success', text: 'タスク「新規作成のテスト2」を登録しました。'
        end

        it '一覧画面が表示される' do
          # タスク内容入力
          visit_new_task
          fill_in 'textarea1', with: input_values[:title]
          fill_in 'textarea2', with: input_values[:description]
          select value = input_values[:label], from: 'task[label_ids][]'
          click_button 'submit'
          expect(page).to have_current_path tasks_path
        end
      end
    end

    describe '画面遷移機能' do
      context '一覧へボタンをクリックした場合' do
        it '一覧画面へ遷移できる' do
          visit_new_task
          click_link '一覧に戻る'
          expect(page).to have_current_path tasks_path
        end
      end
    end
  end

  describe '編集機能' do
    let!(:task_a) { FactoryBot.create(:task, :with_label, title: '最初のタスク', description: '最初のタスクを実施する', status: 'not_started', user_id: user.id, label_name: 'label') }
    subject(:visit_task_a_edit){ visit edit_task_path(task_a) }

    describe '表示機能' do
      context '画面を表示した場合' do
        it '編集前のタスク名が表示される' do
          visit_task_a_edit
          expect(page).to have_field 'textarea1', with: '最初のタスク'
        end

        it '編集前の詳細が表示される' do
          visit_task_a_edit
          expect(page).to have_field 'textarea2', with: '最初のタスクを実施する'
        end

        it '編集前のラベルが表示される' do
          visit_task_a_edit
          expect(page).to have_select 'task[label_ids][]', selected: 'label'
        end
      end
    end

    describe '更新機能' do
      let!(:label1) { FactoryBot.create(:label, name: 'new label') }
      context 'タスクの各項目を更新した場合' do
        let(:update_task) {
          {
            title: 'new title',
            description: 'new description',
            label: label1.name
          }
        }

        it 'タスクが更新される' do
          visit_task_a_edit
          # 更新処理
          fill_in 'task[title]', with: update_task[:title]
          fill_in 'task[description]', with: update_task[:description]
          select value = update_task[:label], from: 'task[label_ids][]'
          # ユーザ2に変更する
          click_button 'submit'
          # 画面で入力された内容でDBのデータが更新されている
          expect(Task.find_by(title: update_task[:title], description: update_task[:description])).to be_present
        end

        it 'Flashメッセージが表示される' do
          visit_task_a_edit
          # 更新処理
          fill_in 'textarea1', with: update_task[:title]
          fill_in 'textarea2', with: update_task[:description]
          select value = update_task[:label], from: 'task[label_ids][]'
          click_button 'submit'
          # Flashメッセージが表示される
          expect(page).to have_selector '.alert-success', text: 'タスク「new title」を更新しました。'
        end
      end
    end

    describe '画面遷移機能' do
      context '詳細へボタンをクリックした場合' do
        it '詳細画面へ遷移できる' do
          visit_task_a_edit
          click_link '詳細へ戻る'
          expect(page).to have_current_path task_path(task_a)
        end
      end

      context '一覧へボタンをクリックした場合' do
        it '一覧画面へ遷移できる' do
          visit_task_a_edit
          click_link '一覧に戻る'
          expect(page).to have_current_path tasks_path
        end
      end
    end
  end

  describe 'バリデーション' do

    let!(:user) { FactoryBot.create(:user, name: 'ユーザ1') }
    subject(:visit_new_task){ visit new_task_path }
    describe 'タイトル' do
      context '30文字で入力されている場合' do
        let!(:task) { FactoryBot.create(:task, title: 'あ' * 30, description: '最初のタスクを実施する', status: 'not_started', user_id: user.id) }
        it '登録できる' do
          visit_new_task
          fill_in 'textarea1', with: task.title
          fill_in 'textarea2', with: task.description
          expect { click_button 'submit' }.to change(Task, :count).by(1)
        end
      end

      context '空の場合' do
        let!(:task) { FactoryBot.build(:task, title: '', description: '最初のタスクを実施する', status: 'not_started', user_id: user.id) }
        it 'エラーメッセージが表示される' do
          visit_new_task
          fill_in 'textarea1', with: task.title
          fill_in 'textarea2', with: task.description
          click_button 'submit'
          expect(page).to have_content "タイトルを入力してください"
        end
      end

      context '31文字以上の場合' do
        let!(:task) { FactoryBot.build(:task, title: 'あ' * 31, description: '最初のタスクを実施する', status: 'not_started', user_id: user.id) }
        it 'エラーメッセージが表示される' do
          visit_new_task
          fill_in 'textarea1', with: task.title
          fill_in 'textarea2', with: task.description
          click_button 'submit'
          expect(page).to have_content "タイトルは30文字以内で入力してください"
        end
      end
    end

    describe '説明' do
      context '100文字で入力されている場合' do
        let!(:task) { FactoryBot.build(:task, title: '最初のタスク', description: 'あ' * 100, status: 'not_started', user_id: user.id) }
        it '登録できる' do
          visit_new_task
          fill_in 'textarea1', with: task.title
          fill_in 'textarea2', with: task.description
          expect { click_button 'submit' }.to change(Task, :count).by(1)
        end
      end

      context '空の場合' do
        let!(:task) { FactoryBot.build(:task, title: '最初のタスク', description: '', status: 'not_started', user_id: user.id) }
        it 'エラーメッセージが表示される' do
          visit_new_task
          fill_in 'textarea1', with: task.title
          fill_in 'textarea2', with: task.description
          click_button 'submit'
          expect(page).to have_content "説明を入力してください"
        end
      end

      context '101文字以上の場合' do
        let!(:task) { FactoryBot.build(:task, title: '最初のタスク', description: 'あ' * 101, status: 'not_started', user_id: user.id) }
        it 'エラーメッセージが表示される' do
          visit_new_task
          fill_in 'textarea1', with: task.title
          fill_in 'textarea2', with: task.description
          click_button 'submit'
          expect(page).to have_content "説明は100文字以内で入力してください"
        end
      end
    end
  end

  describe 'メンテナンス機能' do
    let(:user) { FactoryBot.create(:user, password: 'password') }

    describe 'メンテナンス中の場合' do
      before do
        Maintenance.find_by(service_id: 101).update(maintenance_flg: true)
      end

      context 'ログイン画面の場合' do

        it 'メンテナンス中画面が表示される' do
          visit login_path
          expect(page).to have_content 'メンテナンス中'
        end
      end

      context '一覧画面の場合' do
        subject(:visit_tasks) { visit tasks_path }

        it 'メンテナンス中画面が表示される' do
          visit visit_tasks
          expect(page).to have_content 'メンテナンス中'
        end
      end

      context '登録画面の場合' do
        subject(:visit_new_task){ visit new_task_path }

        it 'メンテナンス中画面が表示される' do
          visit_new_task
          expect(page).to have_content 'メンテナンス中'
        end
      end

      context '編集画面の場合' do
        let!(:task_a) { FactoryBot.create(:task, title: '最初のタスク', description: '最初のタスクを実施する', user_id: user.id, status: '1') }
        subject(:visit_task_a_edit){visit edit_task_path(task_a)}

        it 'メンテナンス中画面が表示される' do
          visit_task_a_edit
          expect(page).to have_content 'メンテナンス中'
        end
      end

      context '詳細画面の場合' do
        let!(:task_a) { FactoryBot.create(:task, title: '最初のタスク', description: '最初のタスクを実施する', user_id: user.id) }
        subject(:visit_task_a) { visit task_path(task_a) }

        it 'メンテナンス中画面が表示される' do
          visit_task_a
          expect(page).to have_content 'メンテナンス中'
        end
      end
    end

    describe 'メンテナンス中でない場合' do
      context 'ログイン画面の場合' do

        it  'ログイン画面が表示される' do
          visit login_path
          expect(page).to have_content 'ログイン'
        end
      end

      context '一覧画面の場合' do

        it  '一覧画面が表示される' do
          visit login_path
          fill_in 'session[email]', with: 'sample0@example.com'
          fill_in 'session[password]', with: 'password'
          click_button 'ログイン'

          tasks_path
          expect(page).to have_content 'タスク一覧'
        end
      end

      context '登録画面の場合' do
        subject(:visit_new_task){ visit new_task_path }

        it  '登録画面が表示される' do
          visit login_path
          fill_in 'session[email]', with: 'sample0@example.com'
          fill_in 'session[password]', with: 'password'
          click_button 'ログイン'

          visit_new_task
          expect(page).to have_content 'タスク登録'
        end
      end

      context '編集画面の場合' do
        let!(:task_a) { FactoryBot.create(:task, title: '最初のタスク', description: '最初のタスクを実施する', user_id: user.id, status: '1') }
        subject(:visit_task_a_edit){visit edit_task_path(task_a)}

        it  '編集画面が表示される' do
          visit login_path
          fill_in 'session[email]', with: 'sample0@example.com'
          fill_in 'session[password]', with: 'password'
          click_button 'ログイン'

          visit_task_a_edit
          expect(page).to have_content 'タスク編集'
        end
      end

      context '詳細画面の場合' do
        let!(:task_a) { FactoryBot.create(:task, title: '最初のタスク', description: '最初のタスクを実施する', user_id: user.id) }
        subject(:visit_task_a) { visit task_path(task_a) }

        it  '詳細画面が表示される' do
          visit login_path
          fill_in 'session[email]', with: 'sample0@example.com'
          fill_in 'session[password]', with: 'password'
          click_button 'ログイン'

          visit_task_a
          expect(page).to have_content '最初のタスクの詳細'
        end
      end
    end
  end
end
