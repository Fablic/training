require 'rails_helper'

RSpec.describe 'Labels', type: :system do
  let!(:normal_user) { create(:normal_user) }
  let!(:task) { create(:task, user: normal_user) }
  let!(:normal_user_label) { create(:label, user_id: normal_user.id) }

  let!(:other_user) { create(:other_user) }
  let!(:other_user_task) { create(:task, user: other_user) }
  let!(:other_user_label) { create(:label, user_id: other_user.id) }

  let!(:new_label_name) { 'new label' }

  before do
    visit login_path
    fill_in 'session_email', with: normal_user.email
    fill_in 'session_password', with: normal_user.password
    click_button 'ログイン'
  end

  describe 'サイドバー' do
    context 'ラベル一覧リンクをクリックした時' do
      before { visit tasks_path }
      it 'ラベル一覧画面に正常に遷移できること' do
        find('#sidebar-labels-link').click
        expect(current_path).to eq labels_path
      end
    end
  end

  describe '一覧ページ' do
    before { visit labels_path}
    context 'アクセスし時' do
      it '画面が正常に表示されること' do
        expect(all('.label-name')[0].value).to match normal_user_label.name
      end

      it 'ログインユーザー以外のラベルが表示されないこと' do
        expect(page).not_to have_content other_user_label.name
      end
    end

    context '削除ボタンが押された時' do
      it '削除が正常に行われること' do
        all('.delete-btn')[0].click
        expect(page).to have_no_content normal_user_label.name
      end
    end

    context '他のユーザーのラベルを削除しようとする' do
      it '削除が行われず、一覧ページにリダイレクトされること' do
        delete label_path other_user_label
        expect(Label.where(id: other_user_label.id)).to exist
        expect(current_path).to eq labels_path
      end
    end
    

    describe '新規作成機能' do
      context '空で登録を試みる' do
        it 'バリデーションにかかり登録ができないこと' do
          click_on '新規作成' 
          expect(page).to have_content 'ラベルの作成に失敗しました。'
        end
      end
      
      context '登録済みの名前で登録' do
        it 'バリデーションにかかり登録ができないこと' do
          fill_in 'new-label-name-input', with: normal_user_label.name
          click_on '新規作成' 
          expect(page).to have_content 'ラベルの作成に失敗しました。'
        end
      end

      context '正常な入力' do
        it 'ラベルが新規で追加できること' do
          fill_in 'new-label-name-input', with: new_label_name
          click_on '新規作成' 
          expect(all('.label-name')[1].value).to match new_label_name
        end
      end
    end
    
    describe '更新機能' do
      context '名前を空で入力して更新' do
        it 'バリデーションにかかり登録できないこと' do
          all('.label-name')[0].set('')
          all('.update-btn')[0].click
          expect(page).to have_content 'ラベルの更新に失敗しました。'
        end
      end

      context '他のラベルと同じ名前を入力して更新' do
        it 'バリデーションにかかり登録できないこと' do
          # バリデーションを適用させるためにラベルを作成
          fill_in 'new-label-name-input', with: new_label_name
          click_on '新規作成' 

          all('.label-name')[0].set(new_label_name)
          all('.update-btn')[0].click
          expect(page).to have_content 'ラベルの更新に失敗しました。'
        end
      end

      context '正常な入力' do
        it 'ラベル名が更新されること' do
          all('.label-name')[0].set(new_label_name)
          all('.update-btn')[0].click
          expect(page).to have_content 'ラベルの更新に成功しました。'
        end
      end
    end
  end
end
