require 'rails_helper'

RSpec.describe Task, type: :system do
  let!(:mainte) { create(:maintenance, status: 0) }
  let(:user_taro) { create(:user, name: 'testest', email: Faker::Internet.email, password: 'password') }

  before do
    login(user_taro.email, user_taro.password)
  end

  describe 'メンテナンス表示' do
    context 'メンテナンスモードがオフのとき' do
      before do
        Tasks::Batch::Maintenance.start
        visit current_path
      end

      it 'メンテナンスページが表示される' do
        expect(page).to have_current_path maintenance_path, ignore_query: true
        expect(page).to have_content I18n.t('maintenance.messages.page_title')
        expect(page).to have_content I18n.t('maintenance.messages.page_detail')
      end
    end

    context 'メンテナンスがオンのとき' do
      before do
        mainte.status = 1
        mainte.save
        Tasks::Batch::Maintenance.end
        visit current_path
      end

      it 'タスクページが表示される' do
        expect(page).to have_current_path tasks_path, ignore_query: true
      end
    end
  end
end
