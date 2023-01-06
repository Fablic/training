# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Test cases for User :', type: :system do
  describe 'Admin user test :' do
    let!(:testuser) { FactoryBot.create(:user) }

    before do
      FactoryBot.create_list(:task, 15, user: testuser) { |task, index| task.title = "Spec#{index}" }
      visit login_path
      fill_in 'session_email', with: 'test@test.com'
      fill_in 'session_password', with: 'password'
      click_button 'ログイン'
    end

    describe 'In user list page' do
      context 'when there are tasks,' do
        before do
          visit users_path
        end

        it 'shows correct user info' do
          # 正しい情報が表示されていること
          expect(page).to have_content 'ユーザ一覧'
          expect(page).to have_content 'test'
          expect(page).to have_content 'test@test.com'
          expect(page).to have_content '15'
        end

        context 'test pagenation' do
          before do
            25.times do |i|
              FactoryBot.create(:user, email: "spec#{i}@test.com")
            end
            visit users_path
          end

          it 'pagenation works' do
            expect(page).to have_content '1 2 3 次 › 最後 »'
          end
        end
      end

      context 'when error,' do
        before do
          allow(User).to receive(:all).and_raise(RuntimeError)
          # 一覧画面を開く
          visit users_path
        end

        it 'redirected to 500 error page' do
          expect(page).to have_content '伍〇〇'
        end
      end
    end

    describe 'In new user page' do
      context 'when success,' do
        it 'create user correctly' do
          # 新規画面を開く
          visit new_user_path

          # 新規画面が開いてること
          expect(page).to have_content '新規登録'
          expect(find_field('user_name').text).to be_blank

          fill_in 'user_name', with: 'Spec'
          fill_in 'user_email', with: 'create@spec.com'
          fill_in 'user_password', with: 'pass'
          fill_in 'user_password_confirmation', with: 'pass'

          # 登録
          click_button 'ユーザーを登録する'

          # 正しく登録されていること
          expect(page).to have_content 'ユーザを作成しました。'
          expect(page).to have_content 'ユーザ詳細'
          expect(page).to have_content 'Spec'
          expect(page).to have_content 'create@spec.com'
        end
      end

      context 'when DB insert fail,' do
        before do
          new_user_mock = User.new

          allow(User).to receive(:new).and_return(new_user_mock)
          allow(new_user_mock).to receive(:save).and_return(false)
        end

        it 'shows error message' do
          # 新規画面を開く
          visit new_user_path

          fill_in 'user_name', with: 'Spec'
          fill_in 'user_email', with: 'hogehoge@spec.com'
          fill_in 'user_password', with: 'pass'
          fill_in 'user_password_confirmation', with: 'pass'

          # 登録
          click_button 'ユーザーを登録する'

          # 正しく登録されていること
          expect(page).to have_content '作成に失敗しました'
          expect(page).to have_content '新規登録'
        end
      end

      context 'when validation error,' do
        before do
          # 新規画面を開く
          visit new_user_path
        end

        it 'shows blank error' do
          # 登録
          click_button 'ユーザーを登録する'

          expect(page).to have_content '作成に失敗しました'
          expect(page).to have_content '名前を入力してください'
          expect(page).to have_content 'メールアドレスを入力してください'
          expect(page).to have_content 'パスワードを入力してください'
          expect(page).to have_content '新規登録'
        end

        it 'shows unique error' do
          fill_in 'user_email', with: 'test@test.com'

          # 登録
          click_button 'ユーザーを登録する'

          expect(page).to have_content '作成に失敗しました'
          expect(page).to have_content 'メールアドレスはすでに存在しています'
          expect(page).to have_content '新規登録'
        end
      end

      context 'when system error,' do
        before do
          new_user_mock = User.new

          allow(User).to receive(:new).and_return(new_user_mock)
          allow(new_user_mock).to receive(:save).and_raise(RuntimeError)
        end

        it 'shows error message' do
          # 新規画面を開く
          visit new_user_path

          fill_in 'user_name', with: 'Spec'
          fill_in 'user_email', with: 'hogehoge@spec.com'
          fill_in 'user_password', with: 'pass'
          fill_in 'user_password_confirmation', with: 'pass'

          # 登録
          click_button 'ユーザーを登録する'

          # エラーページが表示されてること
          expect(page).to have_content '伍〇〇'
        end
      end
    end

    describe 'In user detail page' do
      context 'when success,' do
        it 'shows result correctly' do
          # 詳細画面を開く
          visit user_path(testuser)

          # 正しい情報が表示されていること
          expect(page).to have_content 'ユーザ詳細'
          expect(page).to have_content 'test'
          expect(page).to have_content 'test@test.com'
        end
      end

      context 'when not found,' do
        it 'shows 404 page' do
          visit user_path('not_exist_id')
          expect(page).to have_content '肆〇肆'
        end
      end

      context 'when error,' do
        before do
          allow(User).to receive(:find).and_raise(RuntimeError)
        end

        it 'shows 500 page' do
          visit user_path(testuser)
          expect(page).to have_content '伍〇〇'
        end
      end
    end

    describe 'In edit user page:' do
      let!(:user) { FactoryBot.create(:user, email: 'edituser@spec.com') }

      context 'when success,' do
        it 'works correctly' do
          # ユーザ編集画面を開く
          visit edit_user_path(user)

          # titleとdescriptionが正しく表示されること
          expect(page).to have_content 'ユーザ編集'
          expect(page).to have_field 'user_name', with: 'test'
          expect(page).to have_field 'user_email', with: 'edituser@spec.com'

          # titleとdescriptionを入力する
          fill_in 'user_name', with: 'newname'
          fill_in 'user_email', with: 'newemail@spec.com'
          fill_in 'user_password', with: 'hoge'
          fill_in 'user_password_confirmation', with: 'hoge'

          # 更新実行
          click_button 'ユーザーを更新する'

          # 正しく更新されていること
          expect(page).to have_content 'ユーザ情報を更新しました'
          expect(page).to have_content 'ユーザ詳細'
          expect(page).to have_content 'newname'
          expect(page).to have_content 'newemail@spec.com'
        end
      end

      context 'when DB update fail,' do
        before do
          allow(User).to receive(:find).and_return(user)
          allow(user).to receive(:update).and_return(false)
        end

        it 'shows error message' do
          # ユーザ編集画面を開く
          visit edit_user_path(user)

          # 更新実行
          click_button 'ユーザーを更新する'

          # 失敗していること
          expect(page).to have_content '更新に失敗しました。'
          expect(page).to have_content 'ユーザ編集'
        end
      end

      context 'when not found,' do
        it 'shows 404 page' do
          visit edit_user_path('not_exist_id')
          expect(page).to have_content '肆〇肆'
        end
      end

      context 'when system error,' do
        before do
          allow(User).to receive(:find).and_return(user)
          allow(user).to receive(:update).and_raise(RuntimeError)
        end

        it 'shows 500 page' do
          visit edit_user_path(user)
          click_button 'ユーザーを更新する'

          expect(page).to have_content '伍〇〇'
        end
      end
    end

    describe 'For delete user button,', js: true do
      let!(:user) { FactoryBot.create(:user, email: 'deleteuser@spec.com', role: 0) }

      context 'when success,' do
        it 'works correctly' do
          visit user_path(user)
          click_link '削除'
          expect do
            expect(page.accept_confirm).to eq '本当に削除しますか？'
            sleep 0.5
          end.to change(User, :count).by(-1)
          expect(page).to have_content '正常に削除しました'
          is_expected.not_to have_content 'deleteuser@spec.com'
        end
      end

      context 'when last admin user,' do
        it 'delete will fail' do
          visit user_path(testuser)
          click_link '削除'
          expect do
            expect(page.accept_confirm).to eq '本当に削除しますか？'
            sleep 0.5
          end.to change(User, :count).by(0)
          expect(page).to have_content '現在管理者一名しかいないため、削除、また一般ユーザへの変更はできないです。'
          expect(page).to have_content 'test@test.com'
        end
      end

      context 'when DB delete fail,' do
        before do
          visit user_path(user)

          allow(User).to receive(:find).and_return(user)
          allow(user).to receive(:destroy).and_return(false)
        end

        it 'shows error message' do
          visit user_path(user)
          click_link '削除'
          expect do
            expect(page.accept_confirm).to eq '本当に削除しますか？'
            sleep 0.5
          end.to change(User, :count).by(0)
          expect(page).to have_content '削除失敗しました。'
          expect(page).to have_content 'deleteuser@spec.com'
        end
      end

      context 'when not found,' do
        before do
          visit user_path(user)

          allow(User).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
        end

        it 'shows error message' do
          click_link '削除'
          expect do
            expect(page.accept_confirm).to eq '本当に削除しますか？'
            sleep 0.5
          end.to change(Task, :count).by(0)
          expect(page).to have_content '肆〇肆'
        end
      end

      context 'when error,' do
        before do
          visit user_path(user)

          allow(User).to receive(:find).and_return(user)
          allow(user).to receive(:destroy).and_raise(RuntimeError)
        end

        it 'shows error message' do
          click_link '削除'
          expect do
            expect(page.accept_confirm).to eq '本当に削除しますか？'
            sleep 0.5
          end.to change(Task, :count).by(0)
          expect(page).to have_content '伍〇〇'
        end
      end
    end
  end

  describe 'Normal user test :' do
    let!(:testuser) { FactoryBot.create(:user, role: 0) }

    before do
      FactoryBot.create_list(:task, 15, user: testuser) { |task, index| task.title = "Spec#{index}" }
      visit login_path
      fill_in 'session_email', with: 'test@test.com'
      fill_in 'session_password', with: 'password'
      click_button 'ログイン'
    end

    context 'visit admin pages' do
      it 'can not connect users page' do
        visit users_path

        expect(page).to have_content '管理ユーザしか使えない機能です、管理者に連絡してください'
      end
      it 'can not connect detail page' do
        visit user_path(testuser)

        expect(page).to have_content '管理ユーザしか使えない機能です、管理者に連絡してください'
      end
      it 'can not connect edit page' do
        visit edit_user_path(testuser)

        expect(page).to have_content '管理ユーザしか使えない機能です、管理者に連絡してください'
      end
    end
  end

  describe 'maintenance mode:' do
    let(:mainte_flg) { Rails.root.join '/myapp/tmp/maintenance.txt' }
    let!(:testuser) { FactoryBot.create(:user) }

    before do
      File.open(mainte_flg, 'w+') unless File.exist?(mainte_flg)
    end

    after do
      File.delete mainte_flg if File.exist?(mainte_flg)
    end

    it 'turns to 503 page' do
      visit users_path
      expect(page).to have_content '伍〇弎'
      visit edit_user_path(testuser)
      expect(page).to have_content '伍〇弎'
      visit user_path(testuser)
      expect(page).to have_content '伍〇弎'
      visit new_user_path
      expect(page).to have_content '伍〇弎'
    end
  end
end
