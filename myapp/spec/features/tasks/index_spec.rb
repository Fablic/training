# frozen_string_literal: true

require 'rails_helper'

RSpec.feature '/tasks or /' do
  feature '#index' do
    given!(:tasks) { create_list(:task, 11) }

    scenario 'correctly displays tasks' do
      visit root_path

      expect(current_path).to eq '/'
      tasks.each do |task|
        expect(page).to have_content task.name.to_s
        expect(page).to have_content time_zone(task.end_date).to_s
        expect(page).to have_content task.priority.to_s
        expect(page).to have_content task.status.to_s
        expect(page).to have_content task.explanation.to_s
      end
    end

    feature 'clicks link buttons' do
      given(:task) { tasks.first }

      scenario 'renders #new' do
        visit root_path
        click_on '新規作成する'

        expect(current_path).to eq '/tasks/new'
        expect(page).to have_content 'タスクの新規作成'
      end

      scenario 'renders #show' do
        visit root_path
        first(:link, '詳細を確認する').click

        expect(current_path).to eq "/tasks/#{task.id}"
        expect(page).to have_content task.name.to_s
        expect(page).to have_content time_zone(task.end_date).to_s
        expect(page).to have_content task.priority.to_s
        expect(page).to have_content task.status.to_s
        expect(page).to have_content task.explanation.to_s
      end
    end
  end
end
