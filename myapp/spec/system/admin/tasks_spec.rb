# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Task', type: :system do
  context 'when admin user logged in' do
    let(:admin_user) { create(:user, :admin) }
    let(:rspec_session) { {user_id: admin_user.id} }

    describe '#index' do
      let!(:user_1) { create(:user) }
      let!(:user_2) { create(:user) }
      let!(:task_1) { create(:task, user: user_1) }
      let!(:task_2) { create(:task, user: user_1) }
      let!(:task_3) { create(:task, user: user_2) }

      before { visit admin_tasks_path(user_1) }

      it 'displays tasks associated with the user' do
        expect(page).to have_content task_1.id
        expect(page).to have_content task_1.title
        expect(page).to have_content task_1.description
        expect(page).to have_content task_1.due_date.strftime('%F')
        expect(page).to have_content task_1.created_at.strftime('%F %T')
        expect(page).to have_content task_1.status
        expect(page).to have_content task_1.user.name
        expect(page).to have_content task_2.id
        expect(page).to have_content task_2.title
        expect(page).to have_content task_2.description
        expect(page).to have_content task_2.due_date.strftime('%F')
        expect(page).to have_content task_2.created_at.strftime('%F %T')
        expect(page).to have_content task_2.status
        expect(page).to have_content task_2.user.name
      end

      it 'does not display tasks of other users' do
        expect(page).not_to have_content task_3.id
        expect(page).not_to have_content task_3.user.name
      end
    end
  end

  context 'when non admin user logged in' do
    let(:user) { create(:user) }
    let(:rspec_session) { {user_id: user.id} }

    it 'redirect user to root_path' do
      visit admin_users_path

      expect(page).to have_content 'Tasks List'
    end
  end
end
