# frozen_string_literal: true

require 'rails_helper'

RSpec.feature '/tasks or /' do
  feature '#index' do
    feature 'tasks' do
      background do
        create(:task,
               name: 'aqua',
               end_date: end_date_aqua,
               priority: 'high',
               status: 'untouched',
               explanation: 'aqua hara')
        create(:task,
               name: 'kuma',
               end_date: end_date_kuma,
               priority: 'low',
               status: 'touched',
               explanation: 'brown kuma')
      end
      given(:end_date_aqua) { '2022/09/14 17:25' }
      given(:end_date_kuma) { '2022/09/13 18:25' }

      scenario 'correctly displays tasks' do
        visit root_path

        expect(current_path).to eq '/'

        expect(page).to have_content 'aqua'
        expect(page).to have_content end_date_aqua
        expect(page).to have_content '高'
        expect(page).to have_content '未着手'
        expect(page).to have_content 'aqua hara'

        expect(page).to have_content 'kuma'
        expect(page).to have_content end_date_kuma
        expect(page).to have_content '低'
        expect(page).to have_content '着手中'
        expect(page).to have_content 'brown kuma'
      end
    end

    feature "with 'sort: created_at_asc' in search_params" do
      background do
        create(:task,
               name: 'aqua',
               end_date: end_date_aqua,
               priority: 'high',
               status: 'untouched',
               explanation: 'aqua hara')
        create(:task,
               name: 'kuma',
               end_date: end_date_kuma,
               priority: 'low',
               status: 'touched',
               explanation: 'brown kuma')
      end
      given(:end_date_aqua) { '2022/09/14 17:25' }
      given(:end_date_kuma) { '2022/09/13 18:25' }

      scenario 'correctly displays tasks' do
        visit tasks_path

        expect(current_path).to eq '/tasks'

        find("option[value='created_at_asc']").select_option
        click_on '送信'

        expect(page.all('.task')[0].find('.task_name').text).to eq 'aqua'
        expect(page.all('.task')[0].find('.task_end_date').text).to eq '2022/09/14 17:25'
        expect(page.all('.task')[0].find('.task_priority').text).to eq '高'
        expect(page.all('.task')[0].find('.task_status').text).to eq '未着手'
        expect(page.all('.task')[0].find('.task_explanation').text).to eq 'aqua hara'

        expect(page.all('.task')[1].find('.task_name').text).to eq 'kuma'
        expect(page.all('.task')[1].find('.task_end_date').text).to eq '2022/09/13 18:25'
        expect(page.all('.task')[1].find('.task_priority').text).to eq '低'
        expect(page.all('.task')[1].find('.task_status').text).to eq '着手中'
        expect(page.all('.task')[1].find('.task_explanation').text).to eq 'brown kuma'
      end
    end

    feature "with 'sort: created_at_desc' in search_params" do
      background do
        create(:task,
               name: 'aqua',
               end_date: end_date_aqua,
               priority: 'high',
               status: 'untouched',
               explanation: 'aqua hara')
        create(:task,
               name: 'kuma',
               end_date: end_date_kuma,
               priority: 'low',
               status: 'touched',
               explanation: 'brown kuma')
      end
      given(:end_date_aqua) { '2022/09/14 17:25' }
      given(:end_date_kuma) { '2022/09/13 18:25' }

      scenario 'correctly displays tasks' do
        visit tasks_path

        expect(current_path).to eq '/tasks'

        find("option[value='created_at_desc']").select_option
        click_on '送信'

        expect(page.all('.task')[0].find('.task_name').text).to eq 'kuma'
        expect(page.all('.task')[0].find('.task_end_date').text).to eq '2022/09/13 18:25'
        expect(page.all('.task')[0].find('.task_priority').text).to eq '低'
        expect(page.all('.task')[0].find('.task_status').text).to eq '着手中'
        expect(page.all('.task')[0].find('.task_explanation').text).to eq 'brown kuma'

        expect(page.all('.task')[1].find('.task_name').text).to eq 'aqua'
        expect(page.all('.task')[1].find('.task_end_date').text).to eq '2022/09/14 17:25'
        expect(page.all('.task')[1].find('.task_priority').text).to eq '高'
        expect(page.all('.task')[1].find('.task_status').text).to eq '未着手'
        expect(page.all('.task')[1].find('.task_explanation').text).to eq 'aqua hara'
      end
    end

    feature "with 'sort: end_date' in search_params" do
      background { 2.times { create(:task, end_date: nil) } }
      background { create(:task, end_date: '2022/09/15 17:25') }
      background { create(:task, end_date: '2022/09/13 17:25') }
      given!(:tasks) { Task.all }

      feature 'asc' do
        scenario 'correctly displays tasks' do
          visit tasks_path

          expect(current_path).to eq '/tasks'

          find("option[value='end_date_asc']").select_option
          click_on '送信'

          expect(page.all('.task').count).to eq 4
          expect(page.all('.task')[0].find('.task_end_date').text).to eq ''
          expect(page.all('.task')[1].find('.task_end_date').text).to eq ''
          expect(page.all('.task')[2].find('.task_end_date').text).to eq '2022/09/13 17:25'
          expect(page.all('.task')[3].find('.task_end_date').text).to eq '2022/09/15 17:25'
        end
      end

      feature 'desc' do
        scenario 'correctly displays tasks' do
          visit tasks_path

          expect(current_path).to eq '/tasks'

          find("option[value='end_date_desc']").select_option
          click_on '送信'

          expect(page.all('.task')[0].find('.task_end_date').text).to eq '2022/09/15 17:25'
          expect(page.all('.task')[1].find('.task_end_date').text).to eq '2022/09/13 17:25'
          expect(page.all('.task')[2].find('.task_end_date').text).to eq ''
          expect(page.all('.task')[3].find('.task_end_date').text).to eq ''
        end
      end
    end

    feature "with 'keyword: くま' in search_params" do
      given!(:task_aqua) { create(:task, name: 'アクア', explanation: 'アイコンはくま太郎') }
      given!(:task_kuma) { create(:task, name: 'くま二郎', explanation: '毛が茶色い') }
      given!(:task_nyanko) { create(:task, name: 'にゃんこ', explanation: '毛が白い') }

      scenario 'correctly displays tasks' do
        visit tasks_path

        expect(current_path).to eq '/tasks'

        fill_in 'キーワード検索', with: 'くま'
        click_on '送信'

        expect(page.all('.task').count).to eq 2
        expect(page.all('.task')[0].find('.task_name').text).to eq 'アクア'
        expect(page.all('.task')[1].find('.task_name').text).to eq 'くま二郎'
      end
    end

    feature 'clicks link buttons' do
      background do
        create(:task,
               id: 1,
               name: 'aqua',
               end_date: end_date_aqua,
               priority: 'high',
               status: 'untouched',
               explanation: 'aqua hara')
      end
      background { create_list(:task, 3) }
      given(:end_date_aqua) { '2022/09/14 17:25' }

      scenario 'renders #new' do
        visit root_path
        click_on '新規作成する'

        expect(current_path).to eq '/tasks/new'
        expect(page).to have_content 'タスクの新規作成'
      end

      scenario 'renders #show' do
        visit root_path
        first(:link, '詳細を確認する').click

        expect(page).to have_content 'aqua'
        expect(page).to have_content end_date_aqua
        expect(page).to have_content '高'
        expect(page).to have_content '未着手'
        expect(page).to have_content 'aqua hara'
      end
    end
  end
end
