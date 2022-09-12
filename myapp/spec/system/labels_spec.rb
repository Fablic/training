require 'rails_helper'

describe 'Labels', type: :system do
  let(:user) { FactoryBot.create(:user, password: 'password') }

  before do
    login(user, 'password')
  end

  describe '#index' do
    describe '作成エリア' do
      it '作成ボタンを押下することでラベル作成画面へ遷移すること' do
        visit labels_path
        click_on '作成'
        expect(page).to have_current_path new_label_path
      end
    end

    describe '一覧表示エリア' do
      context 'ラベル1件' do
        let!(:label) { FactoryBot.create(:label, name: 'label') }

        it 'ラベル名が一致すること' do
          visit labels_path
          expect(page).to have_content 'label'
        end

        it '詳細ボタンを押下することでラベル詳細画面へ遷移すること' do
          visit labels_path
          click_on '詳細', match: :first
          expect(page).to have_current_path label_path(label)
        end
      end

      context 'ラベル複数件' do
        let!(:label_one) { FactoryBot.create(:label, name: 'name') }
        let!(:label_two) { FactoryBot.create(:label, name: 'second name') }
        let(:tds_one){ all('tbody tr')[0].all('td') }
        let(:tds_two){ all('tbody tr')[1].all('td') }

        it '1件目 ラベル名が一致すること' do
          visit labels_path
          expect(tds_one[0]).to have_content 'name'
        end

        it '1件目 詳細ボタンを押下することでラベル詳細画面へ遷移すること' do
          visit labels_path
          all('a', text: '詳細')[0].click
          expect(page).to have_current_path label_path(label_one)
        end

        it '2件目 ラベル名が一致すること' do
          visit labels_path
          expect(tds_two[0]).to have_content 'second name'
        end

        it '2件目 詳細ボタンを押下することでラベル詳細画面へ遷移すること' do
          visit labels_path
          all('a', text: '詳細')[1].click
          expect(page).to have_current_path label_path(label_two)
        end
      end
    end

    describe 'ページングエリア' do
      context 'ページングなし' do
        before do
          FactoryBot.create(:label, name: 'label_one')
          FactoryBot.create(:label, name: 'label_two')
          FactoryBot.create(:label, name: 'label_three')
          FactoryBot.create(:label, name: 'label_four')
          FactoryBot.create(:label, name: 'label_five')
        end

        it 'ページングが表示されないこと ページ番号1' do
          visit labels_path
          expect(find('div.pagenation-area')).not_to have_content '1'
        end

        it 'ページングが表示されないこと ページ番号2' do
          visit labels_path
          expect(find('div.pagenation-area')).not_to have_content '2'
        end

        it 'ページングが表示されないこと 次ページボタン' do
          visit labels_path
          expect(find('div.pagenation-area')).not_to have_content 'Next'
        end

        it 'ページングが表示されないこと 最終ページボタン' do
          visit labels_path
          expect(find('div.pagenation-area')).not_to have_content 'Last'
        end
      end

      context 'ページングあり' do
        before do
          FactoryBot.create(:label, name: 'label_one')
          FactoryBot.create(:label, name: 'label_two')
          FactoryBot.create(:label, name: 'label_three')
          FactoryBot.create(:label, name: 'label_four')
          FactoryBot.create(:label, name: 'label_five')
          FactoryBot.create(:label, name: 'label_six')
          FactoryBot.create(:label, name: 'label_seven')
          FactoryBot.create(:label, name: 'label_eight')
          FactoryBot.create(:label, name: 'label_nine')
          FactoryBot.create(:label, name: 'label_ten')
          FactoryBot.create(:label, name: 'label_eleven')
        end

        it 'ページングが表示されること ページ番号1' do
          visit labels_path
          expect(find('div.pagenation-area')).to have_content '1'
        end

        it 'ページングが表示されること ページ番号2' do
          visit labels_path
          expect(find('div.pagenation-area')).to have_content '2'
        end

        it 'ページングが表示されること 次ページボタン' do
          visit labels_path
          expect(find('div.pagenation-area')).to have_content 'Next'
        end

        it 'ページングが表示されること 最終ページボタン' do
          visit labels_path
          expect(find('div.pagenation-area')).to have_content 'Last'
        end

        it 'ページ番号2を押下すると次ページの要素が表示されること' do
          visit labels_path
          click_on '2'
          expect(page).to have_content 'label_six'
        end

        it '次ページボタンを押下すると次ページの要素が表示されること' do
          visit labels_path
          click_on 'Next'
          expect(page).to have_content 'label_six'
        end

        it '最終ページボタンを押下すると最終ページの要素が表示されること' do
          visit labels_path
          click_on 'Last'
          expect(page).to have_content 'label_eleven'
        end

        it '最初のページボタンを押下すると最初のページの要素が表示されること' do
          visit labels_path
          click_on 'Last'
          click_on 'First'
          expect(page).to have_content 'label_one'
        end

        it '前のページボタンを押下すると最初のページの要素が表示されること' do
          visit labels_path
          click_on 'Last'
          click_on 'Previous'
          expect(page).to have_content 'label_six'
        end
      end
    end

    describe 'フッターエリア' do
      it 'タスク一覧へボタン押下でタスク一覧画面へ遷移すること' do
        visit labels_path
        click_on 'タスク一覧へ'
        expect(page).to have_current_path root_path
      end
    end
  end

  describe '#new' do
    describe 'エラー表示エリア' do

      context '入力エラー（ラベル名未入力）' do
        let(:input_values) { { name: '' } }

        it 'データ登録されていないこと' do
          visit new_label_path
          fill_in 'label[name]', with: input_values[:name]
          click_on '作成'
          expect(Label.find_by(name: input_values[:name])).to be_nil
        end

        it 'エラーメッセージが表示されること' do
          visit new_label_path
          fill_in 'label[name]', with: input_values[:name]
          click_on '作成'
          expect(page).to have_content 'ラベル名は1文字以上で入力してください'
        end
      end

      context '入力エラー（ラベル名65文字）' do
        let(:input_values) { { name: '1' * 65 } }

        it 'データ登録されていないこと' do
          visit new_label_path
          fill_in 'label[name]', with: input_values[:name]
          click_on '作成'
          expect(Label.find_by(name: input_values[:name])).to be_nil
        end

        it 'エラーメッセージが表示されること' do
          visit new_label_path
          fill_in 'label[name]', with: input_values[:name]
          click_on '作成'
          expect(page).to have_content 'ラベル名は64文字以内で入力してください'
        end
      end
    end

    describe '入力エリア' do
      let(:input_values) { { name: '新規ラベル' } }

      it '入力した値でラベルが作成されていること' do
        visit new_label_path
        fill_in 'label[name]', with: input_values[:name]
        click_on '作成'
        expect(Label.find_by(input_values)).to be_present
      end

      it '作成ボタン押下でラベル一覧画面へ遷移すること' do
        visit new_label_path
        fill_in 'label[name]', with: input_values[:name]
        click_on '作成'
        expect(page).to have_current_path labels_path
      end

      it '作成後メッセージが表示されること' do
        visit new_label_path
        fill_in 'label[name]', with: input_values[:name]
        click_on '作成'
        expect(page).to have_content 'ラベル作成成功'
      end
    end

    describe 'フッターエリア' do
      it 'ラベル一覧へボタン押下でラベル一覧画面へ遷移すること' do
        visit new_label_path
        click_on 'ラベル一覧へ'
        expect(page).to have_current_path labels_path
      end
    end
  end

  describe '#show' do
    let!(:label) { FactoryBot.create(:label, name: 'label') }

    describe '表示エリア' do
      it 'ラベル名が一致すること' do
        visit label_path(label)
        expect(page).to have_content 'label'
      end
    end

    describe 'フッターエリア' do
      it '編集ボタン押下で編集画面へ遷移すること' do
        visit label_path(label)
        click_on '編集'
        expect(page).to have_current_path edit_label_path(label)
      end

      it '削除ボタン押下で項目が削除されること' do
        visit label_path(label)
        click_on '削除'
        expect(Label.find_by(id: label.id)).to be_nil
      end

      it '削除ボタン押下でラベル一覧画面へ遷移すること' do
        visit label_path(label)
        click_on '削除'
        expect(page).to have_current_path labels_path
      end

      it '削除後メッセージが表示されること' do
        visit label_path(label)
        click_on '削除'
        expect(page).to have_content 'ラベル削除成功'
      end

      it 'ラベル一覧へボタン押下でタスク一覧画面へ遷移すること' do
        visit label_path(label)
        click_on 'ラベル一覧へ'
        expect(page).to have_current_path labels_path
      end
    end
  end

  describe '#edit' do
    let!(:label) { FactoryBot.create(:label, name: 'label') }

    describe 'エラー表示エリア' do
      context '入力エラー（ラベル名未入力）' do
        let(:input_values) { { name: '' } }

        it 'データが更新されていないこと' do
          visit edit_label_path(label)
          fill_in 'label[name]', with: input_values[:name]
          click_on '更新'
          expect(Label.find_by(name: input_values[:name])).to be_nil
        end

        it 'エラーメッセージが表示されること' do
          visit edit_label_path(label)
          fill_in 'label[name]', with: input_values[:name]
          click_on '更新'
          expect(page).to have_content 'ラベル名は1文字以上で入力してください'
        end
      end

      context '入力エラー（ラベル65文字）' do
        let(:input_values) { { name: '1' * 65 } }

        it 'データが更新されていないこと' do
          visit edit_label_path(label)
          fill_in 'label[name]', with: input_values[:name]
          click_on '更新'
          expect(Label.find_by(name: input_values[:name])).to be_nil
        end

        it 'エラーメッセージが表示されること' do
          visit edit_label_path(label)
          fill_in 'label[name]', with: input_values[:name]
          click_on '更新'
          expect(page).to have_content 'ラベル名は64文字以内で入力してください'
        end
      end
    end

    describe '入力エリア' do
      let(:label) { FactoryBot.create(:label, name: 'label') }

      context '初期表示' do
        it 'ラベル名が表示されていること' do
          visit edit_label_path(label)
          expect(page).to have_field 'label[name]', with: 'label'
        end
      end

      context '全項目変更' do
        let(:input_values) { { name: 'update label' } }

        it 'ラベルが更新されていること' do
          visit edit_label_path(label)
          fill_in 'label[name]', with: input_values[:name]
          click_on '更新'
          expect(Label.find_by(name: input_values[:name])).to be_present
        end

        it '更新ボタン押下でラベル一覧画面へ遷移すること' do
          visit edit_label_path(label)
          fill_in 'label[name]', with: input_values[:name]
          click_on '更新'
          expect(page).to have_current_path labels_path
        end

        it '更新後メッセージが表示されること' do
          visit edit_label_path(label)
          fill_in 'label[name]', with: input_values[:name]
          click_on '更新'
          expect(page).to have_content 'ラベル更新成功'
        end
      end
    end

    describe 'フッターエリア' do
      it 'ラベル一覧へボタン押下でタスク一覧画面へ遷移すること' do
        visit edit_label_path(label)
        click_on 'ラベル一覧へ'
        expect(page).to have_current_path labels_path
      end
    end
  end
end
