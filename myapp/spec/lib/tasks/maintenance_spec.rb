require 'rails_helper'
require 'rake'

RSpec.describe 'Rake maintenance', type: :system do
  before(:all) do
    Rails.application.load_tasks
  end

  let(:maintenance_text) { '503 Service Unavailable' }
  describe 'maintenance' do
    context 'メンテナンスモードを開始した時' do
      it '503の画面が表示されること' do
        Rake.application['maintenance:start'].invoke
        get login_path
        expect(response.body).to have_content maintenance_text
        expect(response).to have_http_status(503)
      end
    end

    context 'メンテナンスモードを終了した時' do
      it '503の画面が表示されないこと' do
        Rake.application['maintenance:stop'].invoke
        get login_path
        expect(response.body).not_to have_content maintenance_text
        expect(response).not_to have_http_status(503)
      end
    end
  end
end
