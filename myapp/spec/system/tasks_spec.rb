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
        fill_in input_deadline, with: '03-03-2033'

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

  describe '登録画面のバリデーションの動作を確認する', type: :system do
    context '入力項目を空にして登録ボタンをクリック' do
      it '未入力の項目のバリデーションエラー文言が表示される' do
        visit new_task_path
        click_button 'commit'
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_content 'タイトルを入力してください'
        expect(page).to have_content '内容を入力してください'
        expect(page).to have_content '期限を入力してください'
      end
    end

    context 'タイトルに46文字以上を入力して、更新ボタンをクリック' do
      it '文字数制限のバリデーションエラー文言が表示される' do
        visit new_task_path
        fill_in input_title, with: 'a' * 46
        click_button 'commit'
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_content 'タイトルは45文字以内で入力してください'
      end
    end

    context '内容に256文字以上を入力して、更新ボタンをクリック' do
      it '文字数制限のバリデーションエラー文言が表示される' do
        visit new_task_path
        fill_in input_body, with: 'a' * 256
        click_button 'commit'
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_content '内容は255文字以内で入力してください'
      end
    end

    context '期限に過去日を設定して、更新ボタンをクリック' do
      it '期限のバリデーションエラー文言が表示される' do
        visit new_task_path
        fill_in input_deadline, with: '02-02-2020'
        click_button 'commit'
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_content '期限は未来日を設定してください。'
      end
    end

    context '期限に文字列を設定して、更新ボタンをクリック' do
      it '期限のバリデーションエラー文言が表示される' do
        visit new_task_path
        fill_in input_deadline, with: 'aaa'
        click_button 'commit'
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_content '期限を正しく入力してください。'
      end
    end
  end

  describe '編集画面のバリデーションの動作を確認する', type: :system do
    context '入力項目を空にして登録ボタンをクリック' do
      it '未入力の項目のバリデーションエラー文言が表示される' do
        visit root_path
        click_on '#', match: :first
        click_button '編集', match: :first
        fill_in input_title, with: ''
        fill_in input_body, with: ''
        fill_in input_deadline, with: ''

        click_button 'commit'
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_content 'タイトルを入力してください'
        expect(page).to have_content '内容を入力してください'
        expect(page).to have_content '期限を入力してください'
      end
    end

    context 'タイトルに46文字以上を入力して、更新ボタンをクリック' do
      it '文字数制限のバリデーションエラー文言が表示される' do
        visit root_path
        click_on '#', match: :first
        click_button '編集', match: :first
        fill_in input_title, with: 'a' * 46
        click_button 'commit'
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_content 'タイトルは45文字以内で入力してください'
      end
    end

    context '内容に256文字以上を入力して、更新ボタンをクリック' do
      it '文字数制限のバリデーションエラー文言が表示される' do
        visit root_path
        click_on '#', match: :first
        click_button '編集', match: :first
        fill_in input_body, with: 'a' * 256
        click_button 'commit'
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_content '内容は255文字以内で入力してください'
      end
    end
  end

  context '期限に過去日を設定して、更新ボタンをクリック' do
    it '期限のバリデーションエラー文言が表示される' do
      visit new_task_path
      fill_in input_deadline, with: '02-02-2020'
      click_button 'commit'
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content '期限は未来日を設定してください。'
    end
  end

  context '期限に文字列を設定して、更新ボタンをクリック' do
    it '期限のバリデーションエラー文言が表示される' do
      visit new_task_path
      fill_in input_deadline, with: 'aaa'
      click_button 'commit'
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content '期限を正しく入力してください。'
    end
  end
end
