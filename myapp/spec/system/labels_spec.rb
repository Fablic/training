require 'rails_helper'

RSpec.describe 'Labels', type: :system do
  let!(:normal_user) { create(:normal_user) }
  let!(:task) { create(:task, user: normal_user) }
  let!(:normal_user_label) { create(:label, user_id: normal_user.id) }

  let!(:other_user) { create(:other_user) }
  let!(:other_user_task) { create(:task, user: other_user) }
  let!(:other_user_label) { create(:label, user_id: other_user.id) }


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

    context '編集ボタンが押された時' do
      it '正常に遷移すること' do
        all('table tr')[1].click_on '編集'
        expect(current_path).to eq edit_label_path normal_user_label.id
      end
    end
    
    context '削除ボタンが押された時' do
      it '削除が正常に行われること' do
        all('.delete-btn')[0].click
        expect(page).to have_no_content normal_user_label.name
      end
    end

    describe '新規作成機能' do
      context '空で登録を試みる' do
        it 'バリデーションにかかり登録ができないこと' do
          click_on '新規作成' 
        end
      end
      
    end
    
    
  end
  
end
