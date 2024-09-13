require 'rails_helper'

RSpec.describe User, type: :system do
  include LoginHelper

  describe '#new' do
    context 'when user is anonymous' do
      before { visit users_path }

      it 'shows user creation form' do
        expect(page).to have_field 'ユーザーネーム'
        expect(page).to have_field 'パスワード'
        expect(page).to have_button 'Sign Up'
      end
    end
    context 'when user is logged-in' do
      before do
        user_1 = create(:user)
        log_in(user_1)
        visit users_path
      end

      it 'user should be redirected to root path' do
        expect(current_path).to eq root_path
        expect(page).not_to have_button 'Sign Up'
      end
    end
  end

  describe '#create' do
    context 'when user is anonymous' do
      before { visit users_path }

      it 'creates new user successfully' do
        new_user_name = 'JohnDoe'
        new_user_password = 'dummyPassword123!?'
        fill_in 'user[name]', with: new_user_name
        fill_in 'user[password]', with: new_user_password
        click_on 'btn-signup'

        expect(page).to have_content '作成に成功しました'
        expect(current_path).to eq root_path
      end

      it 'failed to create a user due to blank name' do
        new_user_name = ''
        new_user_password = 'dummyPassword123!?'
        fill_in 'user[name]', with: new_user_name
        fill_in 'user[password]', with: new_user_password
        click_on 'btn-signup'

        expect(page).to have_content '作成に失敗しました'
        expect(page).to have_content 'を入力してください'
        expect(current_path).to eq users_path
      end
      it 'failed to create a user due to short name length' do
        new_user_name = 'foo'
        new_user_password = 'dummyPassword123!?'
        fill_in 'user[name]', with: new_user_name
        fill_in 'user[password]', with: new_user_password
        click_on 'btn-signup'

        expect(page).to have_content '作成に失敗しました'
        expect(page).to have_content '5文字以上で入力してください'
        expect(current_path).to eq users_path
      end
      it 'failed to create a user due to blank password' do
        new_user_name = 'JohnDoe'
        new_user_password = ''
        fill_in 'user[name]', with: new_user_name
        fill_in 'user[password]', with: new_user_password
        click_on 'btn-signup'

        expect(page).to have_content '作成に失敗しました'
        expect(page).to have_content 'を入力してください'
        expect(current_path).to eq users_path
      end
    end
  end

  describe '#update' do
  end
end
