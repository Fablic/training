require 'rails_helper'

RSpec.describe Admin::TasksController, type: :system do
  include LoginHelper

  describe '#index' do
    context 'when user is anonymous' do
      before do
        user_1 = create(:user, id: 1)
        visit admin_user_tasks_path(user_1)
      end

      it 'user should be redirected to login page' do
        expect(current_path).to eq login_path
      end
    end
    context 'when user is normal user' do
      before do
        user_1 = create(:user, id: 1)
        log_in(user_1)
        visit admin_user_tasks_path(user_1)
      end

      it 'user should be redirected to root path' do
        expect(current_path).to eq root_path
      end
    end

    context 'when user has permission' do
      before do
        @moderator_1 = create(:user, id: 1, role: User.roles[:role_moderator])
        log_in(@moderator_1)

        @user_1 = create(:user, id: 2)
        visit admin_user_tasks_path(@user_1)
      end

      context 'when there are tasks' do
        before do
          create_list(:task, 3, user_id: @user_1.id)

          visit admin_user_tasks_path(@user_1)
        end

        it 'moderator should see tasks' do
          expect(page).to have_selector('tbody tr', count: 3)
        end
      end
      context 'when target user is nil' do
        before do
          visit admin_user_tasks_path(999)
        end

        it 'should be redirected to 404' do
          expect(current_path).to eq error_path(404)
        end
      end
    end
  end

  describe '#destroy' do
    context 'when user has permission' do
      before do
        @moderator_1 = create(:user, id: 1, name: 'moduser', role: User.roles[:role_moderator])
        log_in(@moderator_1)

        @user_1 = create(:user, id: 2, name: 'user1')
        create(:task, id: 1, user_id: @user_1.id)
        create(:task, id: 2, user_id: @user_1.id)

        visit admin_user_tasks_path(@user_1)
      end

      it 'admin should delete task successfully' do
        find('form[action="/admin/tasks/1"]').click_on 'btn-delete'

        expect(current_path).to eq admin_user_tasks_path(@user_1)
        expect(page).to have_content '削除に成功しました'
        expect(page).to have_css '.table-danger'
      end
    end
  end

end
