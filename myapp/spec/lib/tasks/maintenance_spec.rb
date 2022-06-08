require 'rails_helper'
require 'rake'

RSpec.describe 'rake task maintenance', type: :system do
  before(:all) do
    Rails.application.load_tasks
  end

  let(:maintenance_text) { 'This service is currently under maintenance.' }

  describe 'maintenance' do
    context 'メンテナンスモードを開始した場合' do
      let(:start) { Rake.application['maintenance:start'] }

      it 'メンテナンス画面(ステータス：503)が表示されること' do
        start.invoke
        get root_path
        expect(response.body).to include maintenance_text
        expect(response).to have_http_status(503)
      end
    end

    context 'メンテナンスモードを停止した場合' do
      let(:stop) { Rake.application['maintenance:stop'] }

      it 'メンテナンス画面(ステータス：503)が表示されないこと' do
        stop.invoke
        get root_path
        expect(response.body).not_to include maintenance_text
        expect(response).to have_http_status(302)
      end
    end
  end
end
