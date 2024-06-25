require 'rails_helper'

RSpec.describe 'Mente' do
  let(:maintenance_file) { Rails.root.join('tmp', 'maintenance_mode_on') }
  context 'when maintenance_mode_on' do
    before do
      FileUtils.rm_f(maintenance_file)
      FileUtils.touch(maintenance_file)
    end

    it 'redirects to /maintenance' do
      visit tasks_path

      expect(page).to have_content('ステップ２１：メンテナンス中ですね')
    end
  end

  context 'when maintenance_mode_off' do
    before do
      FileUtils.rm_f(maintenance_file)
    end

    it 'calls the app' do
      visit tasks_path

      expect(page).to have_selector('h2', text: I18n.t('views.common.login'))
      expect(page).to have_field(I18n.t('helpers.label.login.username'))
      expect(page).to have_field(I18n.t('helpers.label.login.password'))
      expect(page).to have_button(I18n.t('views.common.login'))
    end
  end
end
