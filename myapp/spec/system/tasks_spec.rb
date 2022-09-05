require 'rails_helper'

describe 'Tasks', type: :system do
  let(:user) { FactoryBot.create(:user) }

  before do
    login(user, 'password')
  end

  describe '#index' do
    describe '作成エリア' do
      it '作成ボタンを押下することでタスク作成画面へ遷移すること' do
        visit root_path
        click_on '作成'
        expect(page).to have_current_path new_task_path
      end
    end

    describe '検索エリア' do
      before do
        FactoryBot.create(:task, title: 'titleA1', status: 'not_started', user_id: user.id)
        FactoryBot.create(:task, title: 'titleA2', status: 'in_progress', user_id: user.id)
        FactoryBot.create(:task, title: 'titleB1', status: 'not_started', user_id: user.id)
        FactoryBot.create(:task, title: 'titleB2', status: 'in_progress', user_id: user.id)
      end

      context '条件なし検索' do
        let(:conditions) { { title: '', status: '' } }

        it '検索結果の件数が一致すること' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
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
        let(:conditions) { { title: 'A', status: '' } }

        it '検索結果の件数が一致すること' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          click_on '検索'
          expect(all('tbody tr').size).to be(2)
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

      context 'statusのみ指定して検索' do
        let(:conditions) { { title: '', status: '未着手' } }

        it '検索結果の件数が一致すること' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          click_on '検索'
          expect(all('tbody tr').size).to be(2)
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

        it 'titleB1が表示されること' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          click_on '検索'
          expect(page).to have_content 'titleB1'
        end

        it 'titleB2が表示されないこと' do
          visit root_path
          fill_in 'title', with: conditions[:title]
          select value = conditions[:status], from: 'status'
          click_on '検索'
          expect(page).not_to have_content 'titleB2'
        end
      end

      context 'title、statusを指定して検索' do
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

    describe '一覧表示エリア' do
      context 'タスク1件' do
        let!(:task_one) { FactoryBot.create(:task, user_id: user.id) }
        let!(:label_one) { FactoryBot.create(:label, name: 'label', task_id: task_one.id) }

        it 'タイトルが一致すること' do
          visit root_path
          expect(page).to have_content 'title'
        end

        it 'ラベルが一致すること' do
          visit root_path
          expect(page).to have_content 'label'
        end

        it 'ステータスが一致すること' do
          visit root_path
          expect(page).to have_content '未着手'
        end

        it '詳細ボタンを押下することでタスク詳細画面へ遷移すること' do
          visit root_path
          click_on '詳細', match: :first
          expect(page).to have_current_path task_path(task_one)
        end
      end

      context 'タスク複数件' do
        let!(:task_one) { FactoryBot.create(:task, user_id: user.id) }
        let!(:task_two) { FactoryBot.create(:task, title: 'second title', content: 'second content', status: 'in_progress', user_id: user.id) }
        let!(:label_one) { FactoryBot.create(:label, name: 'label', task_id: task_one.id) }
        let!(:label_two) { FactoryBot.create(:label, name: 'second label', task_id: task_two.id) }
        let(:tds_one){ all('tbody tr')[0].all('td') }
        let(:tds_two){ all('tbody tr')[1].all('td') }

        it '1件目 タイトルが一致すること' do
          visit root_path
          expect(tds_one[0]).to have_content 'second title'
        end

        it '1件目 ラベルが一致すること' do
          visit root_path
          expect(tds_one[1]).to have_content 'second label'
        end

        it '1件目 ステータスが一致すること' do
          visit root_path
          expect(tds_one[2]).to have_content '着手中'
        end

        it '1件目 詳細ボタンを押下することでタスク詳細画面へ遷移すること' do
          visit root_path
          all('a', text: '詳細')[0].click
          expect(page).to have_current_path task_path(task_two)
        end

        it '2件目 タイトルが一致すること' do
          visit root_path
          expect(tds_two[0]).to have_content 'title'
        end

        it '2件目 ラベルが一致すること' do
          visit root_path
          expect(tds_two[1]).to have_content 'label'
        end

        it '2件目 ステータスが一致すること' do
          visit root_path
          expect(tds_two[2]).to have_content '未着手'
        end

        it '2件目 詳細ボタンを押下することでタスク詳細画面へ遷移すること' do
          visit root_path
          all('a', text: '詳細')[1].click
          expect(page).to have_current_path task_path(task_one)
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

        it '前のページボタンを押下すると最初のページの要素が表示されること' do
          visit root_path
          click_on 'Last'
          click_on 'Previous'
          expect(page).to have_content 'title_six'
        end
      end
    end
  end

  describe '#new' do
    describe 'エラー表示エリア' do
      context '入力エラー（タイトル未入力）' do
        let(:input_values) {
          {
            title: '',
            content: 'content',
            label1: 'label1',
          }
        }

        it 'データ登録されていないこと' do
          visit new_task_path
          fill_in 'task_form[title]', with: input_values[:title]
          fill_in 'task_form[content]', with: input_values[:content]
          fill_in 'task_form[label1]', with: input_values[:label1]
          click_on '作成'
          expect(Task.find_by(title: input_values[:title], content: input_values[:content])).to be_nil
        end

        it 'エラーメッセージが表示されること' do
          visit new_task_path
          fill_in 'task_form[title]', with: input_values[:title]
          fill_in 'task_form[content]', with: input_values[:content]
          fill_in 'task_form[label1]', with: input_values[:label1]
          click_on '作成'
          expect(page).to have_content 'タイトルは1文字以上で入力してください'
        end
      end

      context '入力エラー（タイトル129文字）' do
        let(:input_values) {
          {
            title: '1' * 129,
            content: 'content',
            label1: 'label1',
          }
        }

        it 'データ登録されていないこと' do
          visit new_task_path
          fill_in 'task_form[title]', with: input_values[:title]
          fill_in 'task_form[content]', with: input_values[:content]
          fill_in 'task_form[label1]', with: input_values[:label1]
          click_on '作成'
          expect(Task.find_by(title: input_values[:title], content: input_values[:content])).to be_nil
        end

        it 'エラーメッセージが表示されること' do
          visit new_task_path
          fill_in 'task_form[title]', with: input_values[:title]
          fill_in 'task_form[content]', with: input_values[:content]
          fill_in 'task_form[label1]', with: input_values[:label1]
          click_on '作成'
          expect(page).to have_content 'タイトルは128文字以内で入力してください'
        end
      end

      context '入力エラー（内容が未入力）' do
        let(:input_values) {
          {
            title: 'title',
            content: '',
            label1: 'label1',
          }
        }

        it 'データ登録されていないこと' do
          visit new_task_path
          fill_in 'task_form[title]', with: input_values[:title]
          fill_in 'task_form[content]', with: input_values[:content]
          fill_in 'task_form[label1]', with: input_values[:label1]
          click_on '作成'
          expect(Task.find_by(title: input_values[:title], content: input_values[:content])).to be_nil
        end

        it 'エラーメッセージが表示されること' do
          visit new_task_path
          fill_in 'task_form[title]', with: input_values[:title]
          fill_in 'task_form[content]', with: input_values[:content]
          fill_in 'task_form[label1]', with: input_values[:label1]
          click_on '作成'
          expect(page).to have_content '内容は1文字以上で入力してください'
        end
      end

      context '入力エラー（内容が1025文字）' do
        let(:input_values) {
          {
            title: 'title',
            content: '1' * 1025,
            label1: 'label1',
          }
        }

        it 'データ登録されていないこと' do
          visit new_task_path
          fill_in 'task_form[title]', with: input_values[:title]
          fill_in 'task_form[content]', with: input_values[:content]
          fill_in 'task_form[label1]', with: input_values[:label1]
          click_on '作成'
          expect(Task.find_by(title: input_values[:title], content: input_values[:content])).to be_nil
        end

        it 'エラーメッセージが表示されること' do
          visit new_task_path
          fill_in 'task_form[title]', with: input_values[:title]
          fill_in 'task_form[content]', with: input_values[:content]
          fill_in 'task_form[label1]', with: input_values[:label1]
          click_on '作成'
          expect(page).to have_content '内容は1024文字以内で入力してください'
        end
      end

      context '入力エラー（ラベル1が65文字）' do
        let(:input_values) {
          {
            title: 'title',
            content: 'content',
            label1: '1' * 65,
          }
        }

        it 'データ登録されていないこと' do
          visit new_task_path
          fill_in 'task_form[title]', with: input_values[:title]
          fill_in 'task_form[content]', with: input_values[:content]
          fill_in 'task_form[label1]', with: input_values[:label1]
          click_on '作成'
          expect(Task.find_by(title: input_values[:title], content: input_values[:content])).to be_nil
        end

        it 'エラーメッセージが表示されること' do
          visit new_task_path
          fill_in 'task_form[title]', with: input_values[:title]
          fill_in 'task_form[content]', with: input_values[:content]
          fill_in 'task_form[label1]', with: input_values[:label1]
          click_on '作成'
          expect(page).to have_content 'ラベル名は64文字以内で入力してください'
        end
      end

      context '入力エラー（ラベル1が65文字）' do
        let(:input_values) {
          {
            title: 'title',
            content: 'content',
            label1: '1' * 65,
          }
        }

        it 'データ登録されていないこと' do
          visit new_task_path
          fill_in 'task_form[title]', with: input_values[:title]
          fill_in 'task_form[content]', with: input_values[:content]
          fill_in 'task_form[label1]', with: input_values[:label1]
          click_on '作成'
          expect(Task.find_by(title: input_values[:title], content: input_values[:content])).to be_nil
        end

        it 'エラーメッセージが表示されること' do
          visit new_task_path
          fill_in 'task_form[title]', with: input_values[:title]
          fill_in 'task_form[content]', with: input_values[:content]
          fill_in 'task_form[label1]', with: input_values[:label1]
          click_on '作成'
          expect(page).to have_content 'ラベルは64文字以内で入力してください'
        end
      end

      context '入力エラー（ラベル1が65文字）' do
        let(:input_values) {
          {
            title: 'title',
            content: 'content',
            label1: '1' * 65,
          }
        }

        it 'データ登録されていないこと' do
          visit new_task_path
          fill_in 'task_form[title]', with: input_values[:title]
          fill_in 'task_form[content]', with: input_values[:content]
          fill_in 'task_form[label1]', with: input_values[:label1]
          click_on '作成'
          expect(Task.find_by(title: input_values[:title], content: input_values[:content])).to be_nil
        end

        it 'エラーメッセージが表示されること' do
          visit new_task_path
          fill_in 'task_form[title]', with: input_values[:title]
          fill_in 'task_form[content]', with: input_values[:content]
          fill_in 'task_form[label1]', with: input_values[:label1]
          click_on '作成'
          expect(page).to have_content 'ラベル名は64文字以内で入力してください'
        end
      end

      context '入力エラー（ラベル1が65文字）' do
        let(:input_values) {
          {
            title: 'title',
            content: 'content',
            label1: '1' * 65,
          }
        }

        it 'データ登録されていないこと' do
          visit new_task_path
          fill_in 'task_form[title]', with: input_values[:title]
          fill_in 'task_form[content]', with: input_values[:content]
          fill_in 'task_form[label1]', with: input_values[:label1]
          click_on '作成'
          expect(Task.find_by(title: input_values[:title], content: input_values[:content])).to be_nil
        end

        it 'エラーメッセージが表示されること' do
          visit new_task_path
          fill_in 'task_form[title]', with: input_values[:title]
          fill_in 'task_form[content]', with: input_values[:content]
          fill_in 'task_form[label1]', with: input_values[:label1]
          click_on '作成'
          expect(page).to have_content 'ラベル名は64文字以内で入力してください'
        end
      end

      context '入力エラー（ラベル1が65文字）' do
        let(:input_values) {
          {
            title: 'title',
            content: 'content',
            label1: '1' * 65,
          }
        }

        it 'データ登録されていないこと' do
          visit new_task_path
          fill_in 'task_form[title]', with: input_values[:title]
          fill_in 'task_form[content]', with: input_values[:content]
          fill_in 'task_form[label1]', with: input_values[:label1]
          click_on '作成'
          expect(Task.find_by(title: input_values[:title], content: input_values[:content])).to be_nil
        end

        it 'エラーメッセージが表示されること' do
          visit new_task_path
          fill_in 'task_form[title]', with: input_values[:title]
          fill_in 'task_form[content]', with: input_values[:content]
          fill_in 'task_form[label1]', with: input_values[:label1]
          click_on '作成'
          expect(page).to have_content 'ラベルは64文字以内で入力してください'
        end
      end
    end

    describe '入力エリア' do
      let(:input_values) {
        {
          title: '新規タスク 全項目入力 タイトル',
          content: '新規タスク 全項目入力 内容',
          label: '新規タスク 全項目入力 ラベル',
        }
      }

      it '入力した値でTaskが作成されていること' do
        visit new_task_path
        fill_in 'task[title]', with: input_values[:title]
        fill_in 'task[content]', with: input_values[:content]
        fill_in 'task[label]', with: input_values[:label]
        click_on '作成'
        expect(Task.find_by(input_values)).to be_present
      end

      it '作成ボタン押下でタスク一覧画面へ遷移すること' do
        visit new_task_path
        fill_in 'task[title]', with: input_values[:title]
        fill_in 'task[content]', with: input_values[:content]
        fill_in 'task[label]', with: input_values[:label]
        click_on '作成'
        expect(page).to have_current_path root_path
      end

      it '作成後メッセージが表示されること' do
        visit new_task_path
        fill_in 'task[title]', with: input_values[:title]
        fill_in 'task[content]', with: input_values[:content]
        fill_in 'task[label]', with: input_values[:label]
        click_on '作成'
        expect(page).to have_content 'タスク作成成功'
      end
    end

    describe 'フッターエリア' do
      it '一覧へボタン押下でタスク一覧画面へ遷移すること' do
        visit new_task_path
        click_on '一覧へ'
        expect(page).to have_current_path root_path
      end
    end
  end

  describe '#show' do
    let(:task_one) { FactoryBot.create(:task) }

    describe '表示エリア' do
      it 'タイトルが一致すること' do
        visit task_path(task_one)
        expect(page).to have_content 'title'
      end

      it 'ラベルが一致すること' do
        visit task_path(task_one)
        expect(page).to have_content 'label'
      end

      it '内容が一致すること' do
        visit task_path(task_one)
        expect(page).to have_content 'content'
      end

      it 'ステータスが一致すること' do
        visit task_path(task_one)
        expect(page).to have_content '未着手'
      end
    end

    describe 'フッターエリア' do
      it '編集ボタン押下で編集画面へ遷移すること' do
        visit task_path(task_one)
        click_on '編集'
        expect(page).to have_current_path edit_task_path(task_one)
      end

      it '削除ボタン押下で項目が削除されること' do
        visit task_path(task_one)
        click_on '削除'
        expect(Task.find_by(id: task_one.id)).to be_nil
      end

      it '削除ボタン押下でタスク一覧画面へ遷移すること' do
        visit task_path(task_one)
        click_on '削除'
        expect(page).to have_current_path root_path
      end

      it '削除後メッセージが表示されること' do
        visit task_path(task_one)
        click_on '削除'
        expect(page).to have_content 'タスク削除成功'
      end

      it '一覧へボタン押下でタスク一覧画面へ遷移すること' do
        visit task_path(task_one)
        click_on '一覧へ'
        expect(page).to have_current_path root_path
      end
    end
  end

  describe '#edit' do
    let(:task_one) { FactoryBot.create(:task) }

    describe 'エラー表示エリア' do
      context '入力エラー（タイトル未入力）' do
        let(:update_task) {
          {
            title: '',
            content: 'こちらはテスト1の内容です。テストテストテストテストテストテストテスト',
            label: 'テスト',
          }
        }

        it 'データが更新されていないこと' do
          visit edit_task_path(task_one)
          fill_in 'task[title]', with: update_task[:title]
          fill_in 'task[content]', with: update_task[:content]
          fill_in 'task[label]', with: update_task[:label]
          click_on '更新'
          expect(Task.find_by(update_task)).to be_nil
        end

        it 'エラーメッセージが表示されること' do
          visit edit_task_path(task_one)
          fill_in 'task[title]', with: update_task[:title]
          fill_in 'task[content]', with: update_task[:content]
          fill_in 'task[label]', with: update_task[:label]
          click_on '更新'
          expect(page).to have_content 'タイトルは1文字以上で入力してください'
        end
      end

      context '入力エラー（タイトル129文字）' do
        let(:update_task) {
          {
            title: '1' * 129,
            content: 'こちらはテスト1の内容です。テストテストテストテストテストテストテスト',
            label: 'テスト',
          }
        }

        it 'データが更新されていないこと' do
          visit edit_task_path(task_one)
          fill_in 'task[title]', with: update_task[:title]
          fill_in 'task[content]', with: update_task[:content]
          fill_in 'task[label]', with: update_task[:label]
          click_on '更新'
          expect(Task.find_by(update_task)).to be_nil
        end

        it 'エラーメッセージが表示されること' do
          visit edit_task_path(task_one)
          fill_in 'task[title]', with: update_task[:title]
          fill_in 'task[content]', with: update_task[:content]
          fill_in 'task[label]', with: update_task[:label]
          click_on '更新'
          expect(page).to have_content 'タイトルは128文字以内で入力してください'
        end
      end

      context '入力エラー（内容が未入力）' do
        let(:update_task) {
          {
            title: 'テスト1',
            content: '',
            label: 'テスト',
          }
        }

        it 'データが更新されていないこと' do
          visit edit_task_path(task_one)
          fill_in 'task[title]', with: update_task[:title]
          fill_in 'task[content]', with: update_task[:content]
          fill_in 'task[label]', with: update_task[:label]
          click_on '更新'
          expect(Task.find_by(update_task)).to be_nil
        end

        it 'エラーメッセージが表示されること' do
          visit edit_task_path(task_one)
          fill_in 'task[title]', with: update_task[:title]
          fill_in 'task[content]', with: update_task[:content]
          fill_in 'task[label]', with: update_task[:label]
          click_on '更新'
          expect(page).to have_content '内容は1文字以上で入力してください'
        end
      end

      context '入力エラー（内容が1025文字）' do
        let(:update_task) {
          {
            title: 'テスト1',
            content: '1' * 1025,
            label: 'テスト',
          }
        }

        it 'データが更新されていないこと' do
          visit edit_task_path(task_one)
          fill_in 'task[title]', with: update_task[:title]
          fill_in 'task[content]', with: update_task[:content]
          fill_in 'task[label]', with: update_task[:label]
          click_on '更新'
          expect(Task.find_by(update_task)).to be_nil
        end

        it 'エラーメッセージが表示されること' do
          visit edit_task_path(task_one)
          fill_in 'task[title]', with: update_task[:title]
          fill_in 'task[content]', with: update_task[:content]
          fill_in 'task[label]', with: update_task[:label]
          click_on '更新'
          expect(page).to have_content '内容は1024文字以内で入力してください'
        end
      end

      context '入力エラー（ラベルが未入力）' do
        let(:update_task) {
          {
            title: 'テスト1',
            content: 'こちらはテスト1の内容です。テストテストテストテストテストテストテスト',
            label: '',
          }
        }

        it 'データが更新されていないこと' do
          visit edit_task_path(task_one)
          fill_in 'task[title]', with: update_task[:title]
          fill_in 'task[content]', with: update_task[:content]
          fill_in 'task[label]', with: update_task[:label]
          click_on '更新'
          expect(Task.find_by(update_task)).to be_nil
        end

        it 'エラーメッセージが表示されること' do
          visit edit_task_path(task_one)
          fill_in 'task[title]', with: update_task[:title]
          fill_in 'task[content]', with: update_task[:content]
          fill_in 'task[label]', with: update_task[:label]
          click_on '更新'
          expect(page).to have_content 'ラベルは1文字以上で入力してください'
        end
      end

      context '入力エラー（ラベルが65文字）' do
        let(:update_task) {
          {
            title: 'テスト1',
            content: 'こちらはテスト1の内容です。テストテストテストテストテストテストテスト',
            label: '1' * 65,
          }
        }

        it 'データが更新されていないこと' do
          visit edit_task_path(task_one)
          fill_in 'task[title]', with: update_task[:title]
          fill_in 'task[content]', with: update_task[:content]
          fill_in 'task[label]', with: update_task[:label]
          click_on '更新'
          expect(Task.find_by(update_task)).to be_nil
        end

        it 'エラーメッセージが表示されること' do
          visit edit_task_path(task_one)
          fill_in 'task[title]', with: update_task[:title]
          fill_in 'task[content]', with: update_task[:content]
          fill_in 'task[label]', with: update_task[:label]
          click_on '更新'
          expect(page).to have_content 'ラベルは64文字以内で入力してください'
        end
      end
    end

    describe '入力エリア' do
      context '初期表示' do
        it 'タイトルが表示されていること' do
          visit edit_task_path(task_one)
          expect(page).to have_field 'task[title]', with: 'title'
        end

        it '内容が表示されていること' do
          visit edit_task_path(task_one)
          expect(page).to have_field 'task[content]', with: 'content'
        end

        it 'ラベルが表示されていること' do
          visit edit_task_path(task_one)
          expect(page).to have_field 'task[label]', with: 'label'
        end

        it 'ステータスが表示されていること' do
          visit edit_task_path(task_one)
          expect(page).to have_select 'task[status]', selected: '未着手'
        end
      end

      context '全項目変更' do
        let(:update_task) {
          {
            title: 'update title',
            content: 'update content',
            label: 'update label',
            status: 'in_progress',
          }
        }

        it '更新されていること' do
          visit edit_task_path(task_one)
          fill_in 'task[title]', with: update_task[:title]
          fill_in 'task[content]', with: update_task[:content]
          fill_in 'task[label]', with: update_task[:label]
          select value = I18n.t("enums.task.status.#{update_task[:status]}"), from: 'task[status]'
          click_on '更新'
          expect(Task.find_by(update_task)).to be_present
        end

        it '更新ボタン押下でタスク一覧画面へ遷移すること' do
          visit edit_task_path(task_one)
          fill_in 'task[title]', with: update_task[:title]
          fill_in 'task[content]', with: update_task[:content]
          fill_in 'task[label]', with: update_task[:label]
          select value = I18n.t("enums.task.status.#{update_task[:status]}"), from: 'task[status]'
          click_on '更新'
          expect(page).to have_current_path root_path
        end

        it '更新後メッセージが表示されること' do
          visit edit_task_path(task_one)
          fill_in 'task[title]', with: update_task[:title]
          fill_in 'task[content]', with: update_task[:content]
          fill_in 'task[label]', with: update_task[:label]
          select value = I18n.t("enums.task.status.#{update_task[:status]}"), from: 'task[status]'
          click_on '更新'
          expect(page).to have_content 'タスク更新成功'
        end
      end

      context 'タイトルのみ変更' do
        let(:update_task) {
          {
            title: 'update title',
            content: task_one[:content],
            label: task_one[:label],
            status: task_one[:status],
          }
        }

        it '更新されていること' do
          visit edit_task_path(task_one)
          fill_in 'task[title]', with: update_task[:title]
          fill_in 'task[content]', with: update_task[:content]
          fill_in 'task[label]', with: update_task[:label]
          select value = I18n.t("enums.task.status.#{update_task[:status]}"), from: 'task[status]'
          click_on '更新'
          expect(Task.find_by(update_task)).to be_present
        end
      end

      context '内容のみ変更' do
        let(:update_task) {
          {
            title: task_one[:title],
            content: 'update content',
            label: task_one[:label],
            status: task_one[:status],
          }
        }

        it '更新されていること' do
          visit edit_task_path(task_one)
          fill_in 'task[title]', with: update_task[:title]
          fill_in 'task[content]', with: update_task[:content]
          fill_in 'task[label]', with: update_task[:label]
          select value = I18n.t("enums.task.status.#{update_task[:status]}"), from: 'task[status]'
          click_on '更新'
          expect(Task.find_by(update_task)).to be_present
        end
      end

      context 'ラベルのみ変更' do
        let(:update_task) {
          {
            title: task_one[:title],
            content: task_one[:content],
            label: 'update label',
            status: task_one[:status],
          }
        }

        it '更新されていること' do
          visit edit_task_path(task_one)
          fill_in 'task[title]', with: update_task[:title]
          fill_in 'task[content]', with: update_task[:content]
          fill_in 'task[label]', with: update_task[:label]
          select value = I18n.t("enums.task.status.#{update_task[:status]}"), from: 'task[status]'
          click_on '更新'
          expect(Task.find_by(update_task)).to be_present
        end
      end

      context 'ステータスのみ変更' do
        let(:update_task) {
          {
            title: task_one[:title],
            content: task_one[:content],
            label: task_one[:label],
            status: 'in_progress',
          }
        }

        it '更新されていること' do
          visit edit_task_path(task_one)
          fill_in 'task[title]', with: update_task[:title]
          fill_in 'task[content]', with: update_task[:content]
          fill_in 'task[label]', with: update_task[:label]
          select value = I18n.t("enums.task.status.#{update_task[:status]}"), from: 'task[status]'
          click_on '更新'
          expect(Task.find_by(update_task)).to be_present
        end
      end

    end

    describe 'フッターエリア' do
      it '一覧へボタン押下でタスク一覧画面へ遷移すること' do
        visit edit_task_path(task_one)
        click_on '一覧へ'
        expect(page).to have_current_path root_path
      end
    end
  end
end
