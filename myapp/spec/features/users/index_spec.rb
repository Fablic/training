# frozen_string_literal: true

require 'rails_helper'

RSpec.feature '/admin/users or /admin' do
  feature '#index' do
    before(:each) { login(user) }

    feature 'users' do
      given!(:user) { create(:user, name: 'user', email: 'user@u.com', role: 'admin') }
      given!(:kuma) { create(:user, name: 'kuma', email: 'kuma@k.com') }
      background { 7.times.map { create(:user) } }
      given!(:nyanko) { create(:user, name: 'nyanko', email: 'nyanko@n.com') }
      given!(:hiyoko) { create(:user, name: 'hiyoko', email: 'hiyoko@h.com') }

      background do
        7.times.map { create(:task, user_id: user.id) }
        6.times.map { create(:task, user_id: kuma.id) }
        5.times.map { create(:task, user_id: nyanko.id) }
        4.times.map { create(:task, user_id: hiyoko.id) }
      end

      feature 'page:1' do
        scenario 'correctly displays users' do
          visit admin_path

          expect(current_path).to eq '/admin'
          expect(page.all('.user').count).to eq 10

          expect(page.all('.user')[0].find('.user_name').text).to eq 'user'
          expect(page.all('.user')[0].find('.user_email').text).to eq 'user@u.com'
          expect(page.all('.user')[0].find('.user_task_count').text).to eq '7'

          expect(page.all('.user')[1].find('.user_name').text).to eq 'kuma'
          expect(page.all('.user')[1].find('.user_email').text).to eq 'kuma@k.com'
          expect(page.all('.user')[1].find('.user_task_count').text).to eq '6'

          expect(page.all('.user')[9].find('.user_name').text).to eq 'nyanko'
          expect(page.all('.user')[9].find('.user_email').text).to eq 'nyanko@n.com'
          expect(page.all('.user')[9].find('.user_task_count').text).to eq '5'
        end
      end

      feature 'page:2' do
        scenario 'correctly displays tasks' do
          visit admin_path
          click_on 'Next'

          expect(current_path).to eq '/admin'
          expect(page.all('.user').count).to eq 1

          expect(page.all('.user')[0].find('.user_name').text).to eq 'hiyoko'
          expect(page.all('.user')[0].find('.user_email').text).to eq 'hiyoko@h.com'
          expect(page.all('.user')[0].find('.user_task_count').text).to eq '4'
        end
      end
    end

    feature 'clicks link buttons' do
      given!(:user) { create(:user, name: 'user_aqua', email: 'user_aqua@u.com', role: 'admin') }
      background do
        create(:task, name: 'first_task_aqua', user_id: user.id)
        create(:task, name: 'second_task_aqua', user_id: user.id)
        create(:task, name: 'third_task_aqua', user_id: user.id)
      end
      background { create_list(:user, 11) }

      scenario 'renders #new' do
        visit admin_path
        click_on '新規作成する'

        expect(current_path).to eq '/admin/users/new'
        expect(page).to have_content 'ユーザーの新規作成'
      end

      scenario 'renders #show' do
        visit admin_path
        first(:link, '詳細を確認する').click

        expect(current_path).to eq "/admin/users/#{user.id}"
        expect(page).to have_content 'first_task_aqua'
        expect(page).to have_content 'second_task_aqua'
        expect(page).to have_content 'third_task_aqua'
        expect(page).to have_content 'user_aqua'
      end

      scenario 'renders #edit' do
        visit admin_path
        first(:link, '編集する').click

        expect(current_path).to eq "/admin/users/#{user.id}/edit"
        expect(page).to have_content 'ユーザー編集'
        expect(page).to have_content 'ユーザー名'
        expect(page).to have_content 'Eメール'
      end

      scenario 'correctly deletes user' do
        visit admin_path

        expect { page.all('button')[1].click }.to change(User, :count).by(-1)
        expect(current_path).to eq '/admin/users'
        expect(page).to have_content 'ユーザーが正常に削除されました'
      end
    end

    feature 'clicks logout buttons' do
      given(:user) { create(:user, role: 'admin') }

      scenario 'redirects to sessions#new' do
        visit admin_path
        expect(page).not_to have_content 'ログイン'

        click_on 'ログアウトする'

        expect(current_path).to eq '/logout'
        expect { visit '/logout' }.to change {
          current_path
        }.from('/logout').to('/login')
        expect(page).to have_content 'ログイン'
      end
    end
  end
end
