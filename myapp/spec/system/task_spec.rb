require 'rails_helper'

RSpec.describe Task, type: :system do
  let(:task) { create(:task) }

  describe 'タスク表示' do
    context 'DBに保存されたデータがある' do
      before do
        create(:task, id: '1', title: 'task1', content: 'task_contetnt1', deadline: '2023/04/27',
                      status: :not_started, created_at: '2023/04/27 09:00')
        create(:task, id: '2', title: 'task2', content: 'task_contetnt2', deadline: '2023/04/26',
                      status: :start, created_at: '2023/04/27 08:00')
        create(:task, id: '3', title: 'task3', content: 'task_contetnt3', deadline: '2023/04/28',
                      status: :completed, created_at: '2023/04/27 10:00')
        visit root_path
      end

      it '一覧ページに作成日降順で表示' do
        expect(current_path).to eq root_path
        expect(page).to have_content '1'
        expect(page).to have_content 'task1'
        expect(page).to have_content 'task_contetnt1'
        expect(page).to have_content '2023/04/27'
        expect(page).to have_content '未着手'
        expect(page).to have_content '2023/04/27 09:00'
        expect(page).to have_content '2'
        expect(page).to have_content 'task2'
        expect(page).to have_content 'task_contetnt2'
        expect(page).to have_content '2023/04/26'
        expect(page).to have_content '着手中'
        expect(page).to have_content '2023/04/27 08:00'
        expect(page).to have_content '3'
        expect(page).to have_content 'task3'
        expect(page).to have_content 'task_contetnt3'
        expect(page).to have_content '2023/04/28'
        expect(page).to have_content '完了'
        expect(page).to have_content '2023/04/27 10:00'

        expect(page).to have_link '詳細'
        expect(page).to have_link '編集'
        expect(page).to have_link '削除'
        expect(page).to have_link '昇順', href: search_tasks_path(deadline_order: 'asc')
        expect(page).to have_link '降順', href: search_tasks_path(deadline_order: 'desc')
        expect(page).to have_field 'title'
        expect(page).to have_select(options: ['未着手', '着手中', '完了'])
        expect(page).to have_button '検索'
        expect(page).to have_link 'クリア'

        within '.tasks' do
          task_titles = all('.task-title').map(&:text)
          expect(task_titles).to eq %w[task3 task1 task2]
        end
      end
    end

    context '作成日順ソートでページングが動作' do
      before do
        create(:task, id: '1', title: 'task1', content: 'task_contetnt1', deadline: '2023/05/01',
                      created_at: '2023/04/26 01:00')
        create(:task, id: '2', title: 'task2', content: 'task_contetnt2', deadline: '2023/04/30',
                      created_at: '2023/04/27 02:00')
        create(:task, id: '3', title: 'task3', content: 'task_contetnt3', deadline: '2023/04/29',
                      created_at: '2023/04/28 03:00')
        create(:task, id: '4', title: 'task4', content: 'task_contetnt4', deadline: '2023/04/28',
                      created_at: '2023/04/29 04:00')
        create(:task, id: '5', title: 'task5', content: 'task_contetnt5', deadline: '2023/04/27',
                      created_at: '2023/04/30 05:00')
        create(:task, id: '6', title: 'task6', content: 'task_contetnt6', deadline: '2023/04/26',
                      created_at: '2023/05/01 06:00')
        visit root_path
      end

      it '２ページ目のタスクが表示されている' do
        expect(page).to have_selector('span', text: 'Next')
        expect(page).to have_link 'Next'
        expect(page).to have_selector('span', text: 'Last')
        expect(page).to have_link 'Last'
        expect(page).to have_selector('span', text: '2')
        expect(page).to have_link '2'
        within '.tasks' do
          task_titles = all('.task-title').map(&:text)
          expect(task_titles).to eq %w[task6 task5 task4 task3 task2]
        end

        find_link('2').click

        expect(page).to have_content '1'
        expect(page).to have_content 'task1'
        expect(page).to have_content 'task_contetnt1'
        expect(page).to have_content '2023/05/01'
        expect(page).to have_content '2023/04/26 01:00'
        expect(page).to have_link '詳細'
        expect(page).to have_link '編集'
        expect(page).to have_link '削除'
        expect(page).to have_link '昇順', href: tasks_path(deadline_order: 'asc')
        expect(page).to have_link '降順', href: tasks_path(deadline_order: 'desc')
        expect(page).to have_css '.first'
        expect(page).to have_link 'First'
        expect(page).to have_css '.prev'
        expect(page).to have_link 'Previous'
        expect(page).to have_link '1'
      end
    end

    context '終了期限の昇順ソートでページングが動作' do
      before do
        create(:task, id: '1', title: 'task1', content: 'task_contetnt1', deadline: '2023/05/01',
                      created_at: '2023/04/26 01:00')
        create(:task, id: '2', title: 'task2', content: 'task_contetnt2', deadline: '2023/04/30',
                      created_at: '2023/04/27 02:00')
        create(:task, id: '3', title: 'task3', content: 'task_contetnt3', deadline: '2023/04/29',
                      created_at: '2023/04/28 03:00')
        create(:task, id: '4', title: 'task4', content: 'task_contetnt4', deadline: '2023/04/28',
                      created_at: '2023/04/29 04:00')
        create(:task, id: '5', title: 'task5', content: 'task_contetnt5', deadline: '2023/04/27',
                      created_at: '2023/04/30 05:00')
        create(:task, id: '6', title: 'task6', content: 'task_contetnt6', deadline: '2023/04/26',
                      created_at: '2023/05/01 06:00')
        visit root_path
      end

      it '２ページ目のタスクが表示されている' do
        click_on '昇順'

        within '.tasks' do
          task_titles = all('.task-title').map(&:text)
          expect(task_titles).to eq %w[task6 task5 task4 task3 task2]
        end

        find_link('2').click

        expect(page).to have_content '1'
        expect(page).to have_content 'task1'
        expect(page).to have_content 'task_contetnt1'
        expect(page).to have_content '2023/05/01'
        expect(page).to have_content '2023/04/26 01:00'
        expect(page).to have_link '詳細'
        expect(page).to have_link '編集'
        expect(page).to have_link '削除'
        expect(page).to have_link '昇順', href: tasks_path(deadline_order: 'asc')
        expect(page).to have_link '降順', href: tasks_path(deadline_order: 'desc')
        expect(page).to have_selector('span', text: 'First')
        expect(page).to have_link 'First'
        expect(page).to have_selector('span', text: 'Previous')
        expect(page).to have_link 'Previous'
        expect(page).to have_selector('span', text: '1')
        expect(page).to have_link '1'
      end
    end

    context '終了期限の降順ソートでページングが動作' do
      before do
        create(:task, id: '1', title: 'task1', content: 'task_contetnt1', deadline: '2023/05/01',
                      created_at: '2023/04/26 01:00')
        create(:task, id: '2', title: 'task2', content: 'task_contetnt2', deadline: '2023/04/30',
                      created_at: '2023/04/27 02:00')
        create(:task, id: '3', title: 'task3', content: 'task_contetnt3', deadline: '2023/04/29',
                      created_at: '2023/04/28 03:00')
        create(:task, id: '4', title: 'task4', content: 'task_contetnt4', deadline: '2023/04/28',
                      created_at: '2023/04/29 04:00')
        create(:task, id: '5', title: 'task5', content: 'task_contetnt5', deadline: '2023/04/27',
                      created_at: '2023/04/30 05:00')
        create(:task, id: '6', title: 'task6', content: 'task_contetnt6', deadline: '2023/04/26',
                      created_at: '2023/05/01 06:00')
        visit root_path
      end

      it '２ページ目のタスクが表示されている' do
        click_on '降順'

        within '.tasks' do
          task_titles = all('.task-title').map(&:text)
          expect(task_titles).to eq %w[task1 task2 task3 task4 task5]
        end

        find_link('2').click

        expect(page).to have_content '6'
        expect(page).to have_content 'task6'
        expect(page).to have_content 'task_contetnt6'
        expect(page).to have_content '2023/04/26'
        expect(page).to have_content '2023/05/01 06:00'
        expect(page).to have_link '詳細'
        expect(page).to have_link '編集'
        expect(page).to have_link '削除'
        expect(page).to have_link '昇順', href: tasks_path(deadline_order: 'asc')
        expect(page).to have_link '降順', href: tasks_path(deadline_order: 'desc')
        expect(page).to have_selector('span', text: 'First')
        expect(page).to have_link 'First'
        expect(page).to have_selector('span', text: 'Previous')
        expect(page).to have_link 'Previous'
        expect(page).to have_selector('span', text: '1')
        expect(page).to have_link '1'
      end
    end

    context '一覧ページの終了期限の昇順ボタンが押された' do
      before do
        create(:task, id: '1', title: 'task1', content: 'task_contetnt1', deadline: '2023/04/29',
          status: :not_started, created_at: '2023/04/27 09:00')
        create(:task, id: '2', title: 'task2', content: 'task_contetnt2', deadline: '2023/04/28',
                      status: :start, created_at: '2023/04/27 08:00')
        create(:task, id: '3', title: 'task3', content: 'task_contetnt3', deadline: '2023/04/27',
                      status: :completed, created_at: '2023/04/27 10:00')
        visit root_path
      end

      it '終了期限の昇順で表示' do
        click_on '昇順'

        expect(current_path).to eq search_tasks_path
        within '.tasks' do
          task_titles = all('.task-title').map(&:text)
          expect(task_titles).to eq %w[task3 task2 task1]
        end
      end
    end

    context '一覧ページの終了期限の降順ボタンが押された' do
      before do
        create(:task, id: '1', title: 'task1', content: 'task_contetnt1', deadline: '2023/04/29',
                      status: :not_started, created_at: '2023/04/27 09:00')
        create(:task, id: '2', title: 'task2', content: 'task_contetnt2', deadline: '2023/04/28',
                      status: :start, created_at: '2023/04/27 08:00')
        create(:task, id: '3', title: 'task3', content: 'task_contetnt3', deadline: '2023/04/27',
                      status: :completed, created_at: '2023/04/27 10:00')
        visit root_path
      end

      it '終了期限の降順で表示' do
        click_on '降順'

        expect(current_path).to eq search_tasks_path
        within '.tasks' do
          task_titles = all('.task-title').map(&:text)
          expect(task_titles).to eq %w[task1 task2 task3]
        end
      end
    end

    context 'DBに保存されたデータがない' do
      it '一覧ページに新規登録ボタン、検索フォームが表示' do
        visit root_path

        expect(current_path).to eq root_path
        expect(page).not_to have_content task.id
        expect(page).not_to have_content task.title
        expect(page).not_to have_content task.content
        expect(page).not_to have_content task.deadline
        expect(page).not_to have_content task.status
        expect(page).not_to have_link '詳細'
        expect(page).not_to have_link '編集'
        expect(page).not_to have_link '削除'
        expect(page).to have_field 'title'
        expect(page).to have_select(status, options: ['未着手', '着手中', '完了'])
        expect(page).to have_button '検索'
        expect(page).to have_link 'クリア'
        expect(page).to have_link '新規登録'
      end
    end

    context '詳細タスクがある' do
      it '詳細ページの表示' do
        visit task_path(task.id)

        expect(current_path).to eq task_path(task.id)
        expect(page).to have_content task.title
        expect(page).to have_content task.content
        expect(page).to have_link 'もどる'
      end
    end

    context '詳細タスクがない' do
      it '該当するリソースがないと表示' do
        task.destroy

        visit task_path(task.id)

        expect(current_path).to eq root_path
        expect(page).to have_content '該当するリソースがありませんでした。'
      end
    end
  end

  describe '検索エリア' do
    context 'statusのみ指定して検索' do
      let!(:task_A1) { create(:task, title: 'titleA1', status: :not_started) }
      let!(:task_A2) { create(:task, title: 'titleA2', status: :start) }
      let!(:task_B1) { create(:task, title: 'titleB1', status: :not_started) }
      let!(:task_B2) { create(:task, title: 'titleB2', status: :start) }
      let(:conditions) { { status: '未着手' } }

      it '検索結果の件数が一致すること' do
        visit root_path

        fill_in 'title', with: ''
        select(value = conditions[:status], from: 'status')
        click_on '検索'

        expect(all('tbody tr').size).to be(2)
      end

      it 'titleA1が表示されること' do
        visit root_path

        fill_in 'title', with: ''
        select(value = conditions[:status], from: 'status')
        click_on '検索'

        expect(page).to have_content 'titleA1'
      end

      it 'titleA2が表示されないこと' do
        visit root_path

        fill_in 'title', with: ''
        select(value = conditions[:status], from: 'status')
        click_on '検索'

        expect(page).not_to have_content 'titleA2'
      end

      it 'titleB1が表示されること' do
        visit root_path

        fill_in 'title', with: ''
        select(value = conditions[:status], from: 'status')
        click_on '検索'

        expect(page).to have_content 'titleB1'
      end

      it 'titleB2が表示されないこと' do
        visit root_path

        fill_in 'title', with: ''
        select(value = conditions[:status], from: 'status')
        click_on '検索'

        expect(page).not_to have_content 'titleB2'
      end

    end

    context 'title、statusを指定して検索' do
      let!(:task_A1) { create(:task, title: 'titleA1', status: :not_started) }
      let!(:task_A2) { create(:task, title: 'titleA2', status: :start) }
      let!(:task_B1) { create(:task, title: 'titleB1', status: :not_started) }
      let!(:task_B2) { create(:task, title: 'titleB2', status: :start) }
      let(:conditions) { { title: 'A', status: '未着手' } }

      it '検索結果の件数が一致すること' do
        visit root_path

        fill_in 'title', with: conditions[:title]
        select(value = conditions[:status], from: 'status')
        click_on '検索'

        expect(all('tbody tr').size).to be(1)
      end

      it 'titleA1が表示されること' do
        visit root_path

        fill_in 'title', with: conditions[:title]
        select(value = conditions[:status], from: 'status')
        click_on '検索'

        expect(page).to have_content 'titleA1'
      end

      it 'titleA2が表示されないこと' do
        visit root_path

        fill_in 'title', with: conditions[:title]
        select(value = conditions[:status], from: 'status')
        click_on '検索'

        expect(page).not_to have_content 'titleA2'
      end

      it 'titleB1が表示されないこと' do
        visit root_path

        fill_in 'title', with: conditions[:title]
        select(value = conditions[:status], from: 'status')
        click_on '検索'

        expect(page).not_to have_content 'titleB1'
      end

      it 'titleB2が表示されないこと' do
        visit root_path

        fill_in 'title', with: conditions[:title]
        select(value = conditions[:status], from: 'status')
        click_on '検索'

        expect(page).not_to have_content 'titleB2'
      end
    end

    context '終了期日のソート条件が無いまま、検索できること' do
      let!(:task_A1) { create(:task, title: 'titleA1', status: :not_started, deadline: '2023/04/27', created_at: '2023/01/30 09:00') }
      let!(:task_A2) { create(:task, title: 'titleA2', status: :start, deadline: '2023/04/28', created_at: '2023/02/29 09:00') }
      let!(:task_B1) { create(:task, title: 'titleB1', status: :not_started, deadline: '2023/04/29', created_at: '2023/03/28 09:00') }
      let!(:task_B2) { create(:task, title: 'titleB2', status: :not_started, deadline: '2023/04/30', created_at: '2023/04/27 09:00') }
      let(:conditions) { { status: '未着手' } }

      it '検索結果の件数が一致すること' do
        visit root_path

        fill_in 'title', with: conditions[:title]
        select(value = conditions[:status], from: 'status')
        click_on '検索'

        within '.tasks' do
          task_titles = all('.task-title').map(&:text)
          expect(task_titles).to eq %w[titleB2 titleB1 titleA1]
        end
        expect(all('tbody tr').size).to be(3)
      end
    end

    context '終了期日の昇順ソートのまま、検索できること' do
      let!(:task_A1) { create(:task, title: 'titleA1', status: :not_started, deadline: '2023/04/27') }
      let!(:task_A2) { create(:task, title: 'titleA2', status: :not_started, deadline: '2023/04/28') }
      let!(:task_B1) { create(:task, title: 'titleB1', status: :not_started, deadline: '2023/04/29') }
      let!(:task_B2) { create(:task, title: 'titleB2', status: :start, deadline: '2023/04/30') }
      let(:conditions) { { status: '未着手' } }

      it '昇順ソートで検索結果の件数が一致すること' do
        visit root_path
        click_on '昇順'

        fill_in 'title', with: conditions[:title]
        select(value = conditions[:status], from: 'status')
        click_on '検索'

        within '.tasks' do
          task_titles = all('.task-title').map(&:text)
          expect(task_titles).to eq %w[titleA1 titleA2 titleB1]
        end
        expect(all('tbody tr').size).to be(3)
      end
    end

    context '終了期日の降順並びのまま、検索できること' do
      let!(:task_A1) { create(:task, title: 'titleA1', status: :not_started, deadline: '2023/04/27', created_at: '2023/04/30 00:00') }
      let!(:task_A2) { create(:task, title: 'titleA2', status: :not_started, deadline: '2023/04/28', created_at: '2023/04/29 00:00') }
      let!(:task_B1) { create(:task, title: 'titleB1', status: :not_started, deadline: '2023/04/29', created_at: '2023/04/28 00:00') }
      let!(:task_B2) { create(:task, title: 'titleB2', status: :start, deadline: '2023/04/30', created_at: '2023/04/27 00:00') }
      let(:conditions) { { status: '未着手' } }

      it '降順ソートで検索結果の件数が一致すること' do
        visit root_path
        click_on '降順'

        fill_in 'title', with: conditions[:title]
        select(value = conditions[:status], from: 'status')
        click_on '検索'

        within '.tasks' do
          task_titles = all('.task-title').map(&:text)
          expect(task_titles).to eq %w[titleB1 titleA2 titleA1]
        end
        expect(all('tbody tr').size).to be(3)
      end
    end
  end

  describe 'タスク登録' do
    it '新規登録ページ表示' do
      visit root_path

      expect(page).to have_link '新規登録'

      click_on '新規登録'

      expect(current_path).to eq new_task_path
      expect(page).to have_field 'task[title]'
      expect(page).to have_field 'task[content]'
      expect(page).to have_field 'task[deadline]'
      expect(page).to have_field 'task[status]'
      expect(page).to have_button '登録'
      expect(page).to have_link 'もどる'
    end

    context 'タスク名、概要、終了期限、ステータスを入力' do
      it 'タスクの登録に成功' do
        visit new_task_path

        fill_in 'task[title]', with: 'test_title'
        fill_in 'task[content]', with: 'test_content'
        fill_in 'task[deadline]', with: '2022/03/27'
        select(value = '着手中', from: 'task[status]')
        click_button '登録'

        expect(current_path).to eq tasks_path
        expect(page).to have_content 'test_title'
        expect(page).to have_content 'test_content'
        expect(page).to have_content '2022/03/27'
        expect(page).to have_content '着手中'
        expect(page).to have_content 'タスクの登録に成功しました。'
      end
    end

    context '概要が未入力' do
      it 'タスクの登録に成功' do
        visit new_task_path

        fill_in 'task[title]', with: 'test_title'
        fill_in 'task[content]', with: ''
        fill_in 'task[deadline]', with: '2022/03/27'
        select(value = '着手中', from: 'task[status]')
        click_button '登録'

        expect(current_path).to eq tasks_path
        expect(page).to have_content 'test_title'
        expect(page).to have_selector('td', text: '')
        expect(page).to have_content '2022/03/27'
        expect(page).to have_content '着手中'
        expect(page).to have_content 'タスクの登録に成功しました。'
      end
    end

    context 'タスク名が未入力' do
      it 'タスクの登録に失敗' do
        visit new_task_path

        fill_in 'task[title]', with: ''
        fill_in 'task[content]', with: 'test_content'
        fill_in 'task[deadline]', with: '2022/03/27'
        select(value = '着手中', from: 'task[status]')
        click_button '登録'

        expect(current_path).to eq tasks_path
        expect(page).to have_content 'タスク名を入力してください'
      end
    end

    context 'タスク名が31文字以上で入力' do
      it 'タスクの登録に失敗' do
        visit new_task_path

        fill_in 'task[title]', with: 'a' * 31
        fill_in 'task[content]', with: 'test_content'
        fill_in 'task[deadline]', with: '2022/03/27'
        select(value = '着手中', from: 'task[status]')
        click_button '登録'

        expect(current_path).to eq tasks_path
        expect(page).to have_content 'タスク名は30文字以内で入力してください'
      end
    end

    context '終了期限が未入力' do
      it 'タスクの登録に失敗' do
        visit new_task_path

        fill_in 'task[title]', with: 'update_title'
        fill_in 'task[content]', with: 'test_content'
        fill_in 'task[deadline]', with: ''
        select(value = '着手中', from: 'task[status]')
        click_button '登録'

        expect(current_path).to eq tasks_path
        expect(page).to have_content '終了期限を入力してください'
      end
    end
  end

  describe 'タスク編集' do
    let!(:task) { create(:task) }

    context '編集タスクがある' do
      it '編集ページの表示に成功' do
        visit root_path

        expect(page).to have_link '編集'

        click_on '編集'

        expect(current_path).to eq edit_task_path(task.id)
        expect(page).to have_field 'task[title]'
        expect(page).to have_field 'task[content]'
        expect(page).to have_field 'task[deadline]'
        expect(page).to have_field 'task[status]'
        expect(page).to have_button '登録'
        expect(page).to have_link 'もどる'
      end
    end

    context '編集タスクがない' do
      it '該当するリソースがないと表示' do
        task.destroy

        visit edit_task_path(task.id)

        expect(current_path).to eq root_path
        expect(page).to have_content '該当するリソースがありませんでした。'
      end
    end

    context 'タスク名、概要、終了期限、ステータスを入力' do
      it 'タスクの更新に成功' do
        visit edit_task_path(task.id)

        fill_in 'task[title]', with: 'update_test'
        fill_in 'task[content]', with: 'update_content'
        fill_in 'task[deadline]', with: '2022/03/27'
        select(value = '着手中', from: 'task[status]')
        click_on '登録'

        expect(current_path).to eq tasks_path
        expect(page).to have_content 'update_test'
        expect(page).to have_content 'update_content'
        expect(page).to have_content '2022/03/27'
        expect(page).to have_content '着手中'
        expect(page).to have_content 'タスクの更新に成功しました。'
      end
    end

    context '概要が未入力' do
      it 'タスクの更新に成功' do
        visit edit_task_path(task.id)

        fill_in 'task[title]', with: 'update_test'
        fill_in 'task[content]', with: ''
        fill_in 'task[deadline]', with: '2022/03/27'
        select(value = '着手中', from: 'task[status]')
        click_button '登録'

        expect(current_path).to eq tasks_path
        expect(page).to have_content 'update_test'
        expect(page).to have_selector('td', text: '')
        expect(page).to have_content '2022/03/27'
        expect(page).to have_content '着手中'
        expect(page).to have_content 'タスクの更新に成功しました。'
      end
    end

    context 'タスク名が未入力' do
      it 'タスクの更新に失敗' do
        visit edit_task_path(task.id)

        fill_in 'task[title]', with: ''
        fill_in 'task[content]', with: 'update_content'
        fill_in 'task[deadline]', with: '2022/03/27'
        select(value = '着手中', from: 'task[status]')
        click_button '登録'

        expect(current_path).to eq task_path(task.id)
        expect(page).to have_content 'タスク名を入力してください'
      end
    end

    context 'タスク名が３１文字以上' do
      it 'タスクの更新に失敗' do
        visit edit_task_path(task.id)

        fill_in 'task[title]', with: 'a' * 31
        fill_in 'task[content]', with: 'update_content'
        fill_in 'task[deadline]', with: '2022/03/27'
        select(value = '着手中', from: 'task[status]')
        click_button '登録'

        expect(current_path).to eq task_path(task.id)
        expect(page).to have_content 'タスク名は30文字以内で入力してください'
      end
    end

    context '終了期限が未入力' do
      it 'タスクの更新に失敗' do
        visit edit_task_path(task.id)

        fill_in 'task[title]', with: 'update_test'
        fill_in 'task[content]', with: 'update_content'
        fill_in 'task[deadline]', with: ''
        select(value = '着手中', from: 'task[status]')
        click_button '登録'

        expect(current_path).to eq task_path(task.id)
        expect(page).to have_content '終了期限を入力してください'
      end
    end

    context '更新タスクがない' do
      it '該当するリソースがないと表示' do
        visit edit_task_path(task.id)

        fill_in 'task[title]', with: 'update_test'
        fill_in 'task[content]', with: 'update_content'
        fill_in 'task[deadline]', with: '2022/03/27'
        select(value = '着手中', from: 'task[status]')
        task.destroy
        click_button '登録'

        expect(current_path).to eq root_path
        expect(page).to have_content '該当するリソースがありませんでした。'
      end
    end
  end

  describe 'タスク削除' do
    let!(:task) { create(:task) }

    context '削除タスクがある' do
      it 'タスクの削除に成功' do
        visit root_path

        expect(page).to have_link '削除'

        click_on '削除'

        expect(current_path).to eq tasks_path
        expect(page).to have_content 'タスクの削除に成功しました。'
        expect(page).not_to have_content task.title
      end
    end

    context '削除タスクがない' do
      it '該当するリソースがないと表示' do
        visit root_path

        task.destroy
        click_on '削除'

        expect(current_path).to eq root_path
        expect(page).to have_content '該当するリソースがありませんでした。'
      end
    end
  end
end
