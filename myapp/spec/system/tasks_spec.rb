require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  context 'when at the register page,' do
    before do
      visit new_task_path()

      fill_in 'task[title]', with: 'spec test title'
      fill_in 'task[description]', with: 'spec test description'
      select I18n.t('enums.task.priority.low'), from: I18n.t('activerecord.attributes.task.priority')
      fill_in 'task[expires_at]', with: '2021-11-19T10:58'

      find('[name=commit]').click
    end

    example 'A task can be registered.' do
      expect(page).to have_content I18n.t('pages.tasks.flash.registered')
    end
  end

  context 'when at the edit page,' do
    let(:task) { FactoryBot.create(:task) }
    let(:params) {
      {
        title: 'title for edit',
        description: 'description for edit',
        status: I18n.t('enums.task.status.done'),
        priority: I18n.t('enums.task.priority.high'),
        expires_at: Time.zone.now,
      }
    }

    example 'the page can be shown.' do
      visit edit_task_path(task)
      expect(page).to have_field 'task[title]', with: task.title
    end

    example 'a task can be updated.' do
      visit edit_task_path(task)
      fill_in 'task[title]', with: params[:title]
      fill_in 'task[description]', with: params[:description]
      select params[:status], from: I18n.t('activerecord.attributes.task.status')
      select params[:priority], from: I18n.t('activerecord.attributes.task.priority')
      fill_in 'task[expires_at]', with: params[:expires_at]
      find('[name=commit]').click

      expect(page).to have_content I18n.t('pages.tasks.flash.edited')
      expect(page).to have_content params[:title]
      expect(page).to have_content params[:description]
      expect(page).to have_content params[:status]
      expect(page).to have_content params[:priority]
      expect(page).to have_content params[:expires_at]
    end
  end

  context 'when deleting a task,' do
    let(:task) { FactoryBot.create(:task) }

    example 'a task can be deleted.' do
      visit task_path(task)
      click_link I18n.t('common.destroy')
      expect { task.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
