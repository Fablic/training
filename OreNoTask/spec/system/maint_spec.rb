# frozen_string_literal: true

require 'rake_helper'

RSpec.describe 'メンテナンス切り替え', type: :system do
  describe 'maint:start' do
    let!(:start) { Rake.application['maint:start'] }
    let!(:stop) { Rake.application['maint:stop'] }

    it 'メンテナンス画面を正しく切り替えできる' do
      visit tasks_path
      expect(page).to have_content 'タスク管理'

      start.invoke

      visit tasks_path
      expect(page).to have_content 'メンテナンス中'

      stop.invoke
      visit tasks_path
      expect(page).to have_content 'タスク管理'
    end
  end
end
