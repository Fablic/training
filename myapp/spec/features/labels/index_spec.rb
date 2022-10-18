# frozen_string_literal: true

require 'rails_helper'

RSpec.feature '/labels' do
  feature '#index' do
    before(:each) { login(user) }

    given(:user) { create(:user, role: 'admin') }

    background do
      create(:label, name: 'aqua')
      create(:label, name: 'kuma')
      7.times.map { create(:label) }
      create(:label, name: 'nyanko')
      create(:label, name: 'hiyoko')
    end

    feature 'page:1' do
      scenario 'correctly displays labels' do
        visit labels_path

        expect(current_path).to eq '/labels'
        expect(page.all('.label').count).to eq 10

        expect(page.all('.label')[0].find('.label_name').text).to eq 'aqua'
        expect(page.all('.label')[1].find('.label_name').text).to eq 'kuma'
        expect(page.all('.label')[9].find('.label_name').text).to eq 'nyanko'
      end
    end

    feature 'page:2' do
      scenario 'correctly displays labels' do
        visit labels_path
        click_on 'Next'

        expect(current_path).to eq '/labels'
        expect(page.all('.label').count).to eq 1

        expect(page.all('.label')[0].find('.label_name').text).to eq 'hiyoko'
      end
    end

    feature 'clicks link buttons' do
      given!(:label) { create(:label, id: 1, name: 'aqua') }
      background { create_list(:label, 11) }

      scenario 'renders #new' do
        visit labels_path
        click_on '新規作成する'

        expect(current_path).to eq '/labels/new'
        expect(page).to have_content 'ラベルの新規作成'
      end

      scenario 'renders #edit' do
        visit labels_path
        first(:link, '編集する').click

        expect(current_path).to eq "/labels/#{label.id}/edit"
        expect(page).to have_content 'ラベル編集'
      end

      scenario 'correctly deletes label' do
        visit labels_path

        expect { page.all('button')[1].click }.to change(Label, :count).by(-1)
        expect(current_path).to eq '/labels'
        expect(page).to have_content 'ラベルが正常に削除されました'
      end
    end

    feature 'clicks logout buttons' do
      scenario 'redirects to sessions#new' do
        visit labels_path
        expect(page).not_to have_content 'ログイン'

        click_on 'ログアウトする'

        expect(current_path).to eq '/logout'
        expect { visit '/logout' }.to change {
          current_path
        }.from('/logout').to('/login')
        expect(page).to have_content 'ログイン'
      end
    end

    feature 'when maintenance execute' do
      given!(:temp) { Rails.root.join '/myapp/tmp/maintenance.txt' }

      before { File.new temp, 'w' unless File.exist? temp }
      after { File.delete temp if File.exist? temp }

      scenario { display_503(labels_path) }
    end
  end

  feature '#index without admin' do
    background do
      login create(:user, role: 'ordinary')
      create_list(:label, 10)
    end

    feature 'clicks new button' do
      scenario 'redirects #index' do
        visit labels_path
        first(:link, '新規作成する').click

        expect(current_path).to eq labels_path
        expect(page).to have_content '権限がないため新規作成ページを開くことが出来ません'
      end
    end

    feature 'clicks edit button' do
      scenario 'redirects #index' do
        visit labels_path
        first(:link, '編集する').click

        expect(current_path).to eq labels_path
        expect(page).to have_content '権限がないため編集ページを開くことが出来ません'
      end
    end

    feature 'clicks destroy button' do
      scenario 'redirects #index' do
        visit labels_path
        page.all('button')[1].click

        expect(current_path).to eq labels_path
        expect(page).to have_content '権限がないため削除することが出来ません'
      end
    end
  end
end
