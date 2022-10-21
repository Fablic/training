require 'rails_helper'

describe 'タスク管理機能', type: :system do
  before do
    SystemMaintenance.create(key: SystemMaintenance::KEY_TASK_MANAGEMENT, maintenance_flg: false)

    # login
    visit login_path
    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: user.password
    click_on I18n.t('button.login')
  end
  let!(:user) { FactoryBot.create(:user, password: 'password') }

  describe '一覧表示機能' do
    subject(:visit_tasks) { visit tasks_path }

    describe '表示機能' do
      context 'タスクが1件存在する場合' do
        let!(:task_a) { FactoryBot.create(:task, :with_label, title: '最初のタスク', description: '最初のタスクを実施する', user_id: user.id, status: Task.statuses[:not_started], label_name: 'label') }
        let(:tds){ all('tbody tr')[0].all('td') }

        it 'タスク名が表示される' do
          visit_tasks
          expect(tds[0]).to have_content '最初のタスク'
        end

        it 'ラベルが表示される' do
          visit_tasks
          expect(tds[1]).to have_content 'label'
        end
      end

      context 'タスクが2件(複数)存在する場合' do
        let!(:task_a) { FactoryBot.create(:task, :with_label, title: '0 title', description: '最初のタスクを実施する', user_id: user.id, status: Task.statuses[:not_started], label_name: '0 label') }
        let!(:task_b) { FactoryBot.create(:task, :with_label, title: '1 title', description: '２つ目のタスクを実施する', user_id: user.id, status: Task.statuses[:not_started], label_name: '1 label') }
        let(:tds){ all('tbody tr')[1].all('td') }

        it 'タスク名が表示される' do
          visit_tasks
          expect(tds[0]).to have_content '1 title'
        end

        it 'ラベルが表示される' do
          visit_tasks
          expect(tds[1]).to have_content '1 label'
        end
      end

      describe '画面遷移機能' do
        let!(:task_a) { FactoryBot.create(:task, title: '0 title', description: '最初のタスクを実施する', user_id: user.id, status: Task.statuses[:not_started]) }
        context '詳細ボタンをクリックした場合' do
          it '詳細画面へ遷移できる' do
            visit_tasks
            click_link I18n.t('button.detail'), match: :first
            expect(page).to have_current_path task_path(task_a)
          end
        end

        context '新規登録ボタンをクリックした場合' do
          it '新規登録画面へ遷移できる' do
            visit_tasks
            click_link I18n.t('link.create')
            expect(page).to have_current_path new_task_path
          end
        end

        context '編集ボタンをクリックした場合' do
          it '編集画面へ遷移できる' do
            visit_tasks
            click_link I18n.t('button.update'), match: :first
            expect(page).to have_current_path edit_task_path(task_a)
          end
        end
      end
    end

    describe '検索機能' do
      let!(:task_A1) { FactoryBot.create(:task, title: 'A1', status: Task.statuses[:not_started], user_id: user.id) }
      let!(:task_A2) { FactoryBot.create(:task, title: 'A2', status: Task.statuses[:in_progress], user_id: user.id) }
      let!(:task_A3) { FactoryBot.create(:task, :with_label, title: 'A3', status: Task.statuses[:not_started], user_id: user.id, label_name: 'label') }
      let!(:task_B1) { FactoryBot.create(:task, title: 'B1', status: Task.statuses[:not_started], user_id: user.id) }
      let!(:task_B2) { FactoryBot.create(:task, title: 'B2', status: Task.statuses[:in_progress], user_id: user.id) }

      context '条件なし' do
        let(:conditions) { { title: '', status: '', label: '' } }

        it '検索結果の件数が一致すること' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(all('tbody tr').size).to be(5)
        end

        it 'A1が表示されること' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(page).to have_content 'A1'
        end

        it 'A2が表示されること' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(page).to have_content 'A2'
        end

        it 'A3が表示されること' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(page).to have_content 'A3'
        end

        it 'B1が表示されること' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(page).to have_content 'B1'
        end

        it 'B2が表示されること' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(page).to have_content 'B2'
        end
      end

      context 'titleのみ指定して検索' do
        let(:conditions) { { title: 'A', status: '', label: '' } }

        it '検索結果の件数が一致すること' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(all('tbody tr').size).to be(3)
        end

        it 'A1が表示されること' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(page).to have_content 'A1'
        end

        it 'A2が表示されること' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(page).to have_content 'A2'
        end

        it 'A3が表示されること' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(page).to have_content 'A3'
        end

        it 'B1が表示されないこと' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(page).not_to have_content 'B1'
        end

        it 'B2が表示されないこと' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(page).not_to have_content 'B2'
        end
      end

      context 'statusのみ指定して検索' do
        let(:conditions) { { title: '', status: '未着手', label: '' } }

        it '検索結果の件数が一致すること' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(all('tbody tr').size).to be(3)
        end

        it 'A1が表示されること' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(page).to have_content 'A1'
        end

        it 'A2が表示されないこと' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(page).not_to have_content 'A2'
        end

        it 'A3が表示されること' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(page).to have_content 'A3'
        end

        it 'B1が表示されること' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(page).to have_content 'B1'
        end

        it 'titleB2が表示されないこと' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(page).not_to have_content 'titleB2'
        end
      end

      context 'title、statusを指定して検索' do
        let(:conditions) { { title: 'A', status: '未着手', label: '' } }

        it '検索結果の件数が一致すること' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(all('tbody tr').size).to be(2)
        end

        it 'A1が表示されること' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(page).to have_content 'A1'
        end

        it 'A2が表示されないこと' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(page).not_to have_content 'A2'
        end

        it 'A3が表示されること' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(page).to have_content 'A3'
        end

        it 'B1が表示されないこと' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(page).not_to have_content 'B1'
        end

        it 'B2が表示されないこと' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(page).not_to have_content 'B2'
        end
      end

      context 'labelのみ指定して検索' do
        let(:conditions) { { title: '', status: '', label: 'label' } }

        it '検索結果の件数が一致すること' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(all('tbody tr').size).to be(1)
        end

        it 'A1が表示されないこと' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(page).not_to have_content 'A1'
        end

        it 'A2が表示されないこと' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(page).not_to have_content 'A2'
        end

        it 'A3が表示されること' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(page).to have_content 'A3'
        end

        it 'B1が表示されないこと' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(page).not_to have_content 'B1'
        end

        it 'B2が表示されないこと' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          select value = conditions[:label], from: 'label'
          click_on '検索'
          expect(page).not_to have_content 'B2'
        end
      end
    end

    describe 'ページング機能' do
      context 'タスク5件以内' do
        before do
          FactoryBot.create(:task, title: 'title_one')
          FactoryBot.create(:task, title: 'title_two')
          FactoryBot.create(:task, title: 'title_three')
          FactoryBot.create(:task, title: 'title_four')
          FactoryBot.create(:task, title: 'title_five')
        end

        it 'ページングが表示されないこと 1' do
          visit root_path
          expect(find('div.pagenation')).not_to have_content '1'
        end

        it 'ページングが表示されないこと 2' do
          visit root_path
          expect(find('div.pagenation')).not_to have_content '2'
        end

        it 'ページングが表示されないこと Next' do
          visit root_path
          expect(find('div.pagenation')).not_to have_content 'Next'
        end

        it 'ページングが表示されないこと Last' do
          visit root_path
          expect(find('div.pagenation')).not_to have_content 'Last'
        end
      end

      context 'タスク11件' do
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

        it 'ページングが表示されること 1' do
          visit root_path
          expect(find('div.pagenation')).to have_content '1'
        end

        it 'ページングが表示されること 2' do
          visit root_path
          expect(find('div.pagenation')).to have_content '2'
        end

        it 'ページングが表示されること Next' do
          visit root_path
          expect(find('div.pagenation')).to have_content 'Next'
        end

        it 'ページングが表示されること Last' do
          visit root_path
          expect(find('div.pagenation')).to have_content 'Last'
        end

        it '「2」を押下すると6件目のタスクが表示されること' do
          visit root_path
          click_on '2'
          expect(page).to have_content 'title_six'
        end

        it '「Next」を押下すると6件目のタスクが表示されること' do
          visit root_path
          click_on 'Next'
          expect(page).to have_content 'title_six'
        end

        it '「Last」を押下すると11件目のタスクが表示されること' do
          visit root_path
          click_on 'Last'
          expect(page).to have_content 'title_eleven'
        end

        it '「First」を押下すると1件目のタスクが表示されること' do
          visit root_path
          click_on 'Last'
          click_on 'First'
          expect(page).to have_content 'title_one'
        end

        it '「Last」を押下後に「Previous」を押下すると6件目のタスクが表示されること' do
          visit root_path
          click_on 'Last'
          click_on 'Previous'
          expect(page).to have_content 'title_six'
        end
      end
    end

    describe 'メンテナンス機能' do
      context 'メンテナンスが未開始状態の場合'do
        before do
          SystemMaintenance.find_by(SystemMaintenance::KEY_TASK_MANAGEMENT).update(maintenance_flg: false)
        end

        it 'タスク一覧画面への遷移で503エラーが表示されないこと' do
          visit root_path
          expect(page).not_to have_content '503 Service Unavailable'
        end
      end

      context 'メンテナンスが開始状態の場合'do
        before do
          SystemMaintenance.find_by(SystemMaintenance::KEY_TASK_MANAGEMENT).update(maintenance_flg: true)
        end

        it 'タスク一覧画面への遷移で503エラーが表示されること' do
          visit root_path
          expect(page).to have_content '503 Service Unavailable'
        end
      end
    end
  end

  describe '詳細表示機能' do
    let!(:task_a) { FactoryBot.create(:task, :with_label, title: '0 title', description: '最初のタスクを実施する', user_id: user.id, status: Task.statuses[:not_started], label_name: '0 label') }
    subject(:visit_task_a) { visit task_path(task_a) }

    describe '表示機能' do
      context 'タスクが存在する場合' do
        it 'タスク名が表示される' do
          visit_task_a
          expect(page).to have_content '0 title'
        end

        it '詳細が表示される' do
          visit_task_a
          expect(page).to have_content '最初のタスクを実施する'
        end

        it 'ラベルが表示される' do
          visit_task_a
          expect(page).to have_content '0 label'
        end
      end
    end

    describe '画面遷移機能' do
      context '一覧へボタンをクリックした場合' do
        it '一覧画面へ遷移できる' do
          visit_task_a
          click_link I18n.t('link.back')
          expect(page).to have_current_path tasks_path
        end
      end
    end

    describe 'メンテナンス機能' do
      context 'メンテナンス未開始の場合'do
        before do
          SystemMaintenance.find_by(SystemMaintenance::KEY_TASK_MANAGEMENT).update(maintenance_flg: false)
        end

        it 'タスク一覧画面への遷移で503エラーが表示されないこと' do
          visit_task_a
          expect(page).not_to have_content '503 Service Unavailable'
        end
      end

      context 'メンテナンスが開始状態の場合'do
        before do
          SystemMaintenance.find_by(SystemMaintenance::KEY_TASK_MANAGEMENT).update(maintenance_flg: true)
        end

        it 'タスク一覧画面への遷移で503エラーが表示されること' do
          visit_task_a
          expect(page).to have_content '503 Service Unavailable'
        end
      end
    end
  end

  describe '新規登録機能' do
    subject(:visit_new_task){ visit new_task_path }

    context 'タスクの各項目を登録した場合' do
      let(:input_values) {
        {
          title: '新規作成のテスト2',
          description: '新規作成のテストを書く2',
          user_id: user.id,
        }
      }

      it 'タスクが正常に登録される' do
        visit_new_task
        # 登録処理
        fill_in 'textarea1', with: '新規作成のテスト2'
        fill_in 'textarea2', with: '新規作成のテストを書く2'
        expect { click_button 'submit' }.to change(Task, :count).by(1)
      end
    end

    describe '画面遷移機能' do
      let!(:task_a) { FactoryBot.create(:task, title: '最初のタスク', description: '最初のタスクを実施する', user_id: user.id, status: Task.statuses[:not_started]) }

      context '新規登録ボタンをクリックした場合' do
        it '一覧画面へ遷移できる' do
          visit_new_task
          click_button 'submit'
          expect(page).to have_current_path tasks_path
        end
      end

      context '一覧へボタンをクリックした場合' do
        it '一覧画面へ遷移できる' do
          visit_new_task
          click_link I18n.t('link.back')
          expect(page).to have_current_path tasks_path
        end
      end
    end

    describe 'メンテナンス機能' do
      context 'メンテナンス未開始の場合'do
        before do
          SystemMaintenance.find_by(SystemMaintenance::KEY_TASK_MANAGEMENT).update(maintenance_flg: false)
        end

        it 'タスク一覧画面への遷移で503エラーが表示されないこと' do
          visit_new_task
          expect(page).not_to have_content '503 Service Unavailable'
        end
      end

      context 'メンテナンス開始の場合'do
        before do
          SystemMaintenance.find_by(SystemMaintenance::KEY_TASK_MANAGEMENT).update(maintenance_flg: true)
        end

        it 'タスク一覧画面への遷移で503エラーが表示されること' do
          visit_new_task
          expect(page).to have_content '503 Service Unavailable'
        end
      end
    end
  end

  describe '編集機能' do
    let!(:task_a) { FactoryBot.create(:task, :with_label, title: '最初のタスク', description: '最初のタスクを実施する', user_id: user.id, status: Task.statuses[:not_started], label_name: 'label') }
    let!(:label_a) { FactoryBot.create(:label, name: 'update label') }
    subject(:visit_task_a_edit){visit edit_task_path(task_a)}

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
      end

      context 'タスクの各項目を更新した場合' do
        let(:input_values) {
          {
            title: '最初のタスク',
            description: '最初のタスクを実施する',
            user_id: user.id,
            label: label_a.name,
          }
        }

        it 'タスクが正常に更新される' do
          visit_task_a_edit
          # 更新処理
          fill_in 'textarea1', with: input_values[:title]
          fill_in 'textarea2', with: input_values[:description]
          select value = input_values[:label], from: 'task[label_ids][]'
          # 画面で入力された内容でDBのデータが更新されている
          expect(Task.find_by(title: input_values[:title], description: input_values[:description])).to be_present
        end

        it 'タスクとラベルが正常に紐づく' do
          visit_task_a_edit
          # 更新処理
          fill_in 'textarea1', with: input_values[:title]
          fill_in 'textarea2', with: input_values[:description]
          select value = input_values[:label], from: 'task[label_ids][]'
          # 画面で入力された内容でDBのデータが更新されている
          expect(Label.find_by(name: input_values[:label])).to be_present
        end
      end

      describe '画面遷移機能' do
        context '一覧へボタンをクリックした場合' do
          it '一覧画面へ遷移できる' do
            visit_task_a_edit
            click_link I18n.t('link.back')
            expect(page).to have_current_path tasks_path
          end
        end
      end
    end

    describe 'メンテナンス機能' do
      context 'メンテナンス未開始の場合'do
        before do
          SystemMaintenance.find_by(SystemMaintenance::KEY_TASK_MANAGEMENT).update(maintenance_flg: false)
        end

        it 'タスク一覧画面への遷移で503エラーが表示されないこと' do
          visit_task_a_edit
          expect(page).not_to have_content '503 Service Unavailable'
        end
      end

      context 'システムが停止状態の場合'do
        before do
          SystemMaintenance.find_by(SystemMaintenance::KEY_TASK_MANAGEMENT).update(maintenance_flg: true)
        end

        it 'タスク一覧画面への遷移で503エラーが表示されること' do
          visit_task_a_edit
          expect(page).to have_content '503 Service Unavailable'
        end
      end
    end
  end
end
