require 'rails_helper'

RSpec.describe Admin::SettingsController, type: :system do
  include LoginHelper

  describe '#index' do
    context 'when user is anonymous' do
      before do
        visit admin_settings_path
      end

      it 'user should be redirected to login page' do
        expect(current_path).to eq login_path
      end
    end
    context 'when user is normal user' do
      before do
        user_1 = create(:user)
        log_in(user_1)
        visit admin_settings_path
      end

      it 'user should be redirected to root path' do
        expect(current_path).to eq root_path
      end
    end

    context 'when user has permission' do
      before do
        @moderator_1 = create(:user, role: User.roles[:role_moderator])
        log_in(@moderator_1)
        visit admin_settings_path
      end

      it 'user should access admin settings page' do
        expect(current_path).to eq admin_settings_path

        expect(page).to have_field 'maintenance[is_maintenance]'
        expect(page).to have_checked_field 'off'
        expect(page).to have_no_checked_field 'on'
        expect(page).to have_field 'maintenance[started_at]'
        expect(page).to have_field 'maintenance[ended_at]'
        expect(page).to have_button 'Submit'
      end

      context 'when there is a maintenance schedule' do
        before do
          @maintenance_1 = create(:maintenance, is_maintenance: 1, started_at: '2024-09-01T15:00:00', ended_at: '2024-09-01T15:15:00')
          visit admin_settings_path
        end

        it 'user should see current maintenance schedule' do
          expect(page).to have_field 'maintenance[is_maintenance]'
          expect(page).to have_checked_field 'on'
          expect(page).to have_no_checked_field 'off'
          expect(page).to have_field 'maintenance[started_at]', with: '2024-09-01T15:00:00'
          expect(page).to have_field 'maintenance[ended_at]', with: '2024-09-01T15:15:00'
          expect(page).to have_button 'Submit'
        end
      end
    end
  end

  describe '#create' do
    context 'when user has permission' do
      before do
        @moderator_1 = create(:user, role: User.roles[:role_moderator])
        log_in(@moderator_1)
        visit admin_settings_path
      end

      it 'set new maintenance schedule successfully' do
        choose 'maintenance_is_maintenance_on'
        fill_in 'maintenance[started_at]', with: '2024-09-01T15:15:00'
        fill_in 'maintenance[ended_at]', with: '2024-09-01T15:30:00'
        click_on 'Submit'

        expect(current_path).to eq admin_settings_path
        expect(page).to have_content '更新に成功しました'
        expect(page).to have_field 'maintenance[is_maintenance]'
        expect(page).to have_checked_field 'on'
        expect(page).to have_no_checked_field 'off'
        expect(page).to have_field 'maintenance[started_at]', with: '2024-09-01T15:15:00'
        expect(page).to have_field 'maintenance[ended_at]', with: '2024-09-01T15:30:00'
        expect(page).to have_button 'Submit'
      end

      context 'when user creation is failed' do
        before do
          visit admin_settings_path

          choose 'maintenance_is_maintenance_on'
          fill_in 'maintenance[started_at]', with: '2024-09-01T15:15:00'
          fill_in 'maintenance[ended_at]', with: '2024-09-01T15:00:00'
          click_on 'Submit'
        end

        it 'error message is shown on the same page' do
          expect(current_path).to eq admin_settings_path
          expect(page).to have_content '更新に失敗しました'
          expect(page).to have_content 'より大きい値にしてください'

          expect(page).to have_field 'maintenance[is_maintenance]'
          expect(page).to have_checked_field 'on'
          expect(page).to have_no_checked_field 'off'
          expect(page).to have_field 'maintenance[started_at]', with: '2024-09-01T15:15:00'
          expect(page).to have_field 'maintenance[ended_at]', with: '2024-09-01T15:00:00'
        end
      end
    end
  end

end
