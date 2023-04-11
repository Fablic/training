require 'rails_helper'

RSpec.describe 'Maintenance', type: :system do
  let(:file_path) { 'tmp/maintenance.txt' }

  after do
    File.delete(file_path) if File.exist?(file_path)
  end

  describe 'render_maintenance' do
    context 'maintenance_mode? is true' do
      before do
        File.write('tmp/maintenance.txt', '')
      end

      it 'shows maintenance mode view' do
        visit '/login'
        expect(page).to have_content '503'
      end
    end

    context 'maintenance_mode? is false' do
      it 'shows login page' do
        visit '/login'
        expect(page).to have_content 'ログイン'
        expect(page).to have_content 'メールアドレス'
        expect(page).to have_content 'パスワード'
      end
    end
  end
end
