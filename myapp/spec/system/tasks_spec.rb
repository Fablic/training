feature 'tasks', type: :system, js: true do

  let(:input_title ){ 'task[title]'}
  let(:input_body ){ 'task[body]'}
  let(:input_deadline ){ 'task[deadline]'}
  describe 'タスクを登録する', type: :system do
    context '登録画面の入力項目を埋めて、登録ボタンをクリック' do
      it 'root_pathに遷移する。登録したtest_titleの文字列が表示されている。' do
        visit new_task_path
        fill_in input_title, with: 'test title'
        fill_in input_body, with: 'test body'
        fill_in input_deadline, with: '02-02-2022'

        click_button 'commit'
        page.driver.browser.switch_to.alert.accept

        expect(current_path).to eq root_path
        expect(page).to have_content 'test title'

        click_on '#', match: :first
        expect(page).to have_content 'test title'
        expect(page).to have_content 'test body'
      end
    end
  end

  describe 'タスクを編集する', type: :system do
    context '編集画面でtitle,body,deadlineの項目を修正して更新ボタンをクリック' do
      it 'root_pathに遷移する。更新したtitleが表示されている。' do
        visit root_path
        click_on '#', match: :first
        click_button '編集', match: :first
        fill_in input_title, with: 'edit test title'
        fill_in input_body, with: 'edit test body'
        fill_in input_deadline, with: '03-03-2033'

        click_button 'commit'
        page.driver.browser.switch_to.alert.accept

        expect(current_path).to eq root_path
        expect(page).to have_content 'edit test title'
      end
    end
  end

  describe 'タスクを削除する', type: :system do
    context '詳細画面で削除ボタンをクリック' do
      it 'root_pathに遷移する。削除対象のtitleが表示されない。' do
        visit root_path
        click_on '#', match: :first
        click_button '削除', match: :first

        expect(page).not_to have_content 'edit test title'
      end
    end
  end
end
