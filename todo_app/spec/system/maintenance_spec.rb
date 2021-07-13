# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maintenance', type: :system do
  describe 'メンテナンスファイルが存在する場合' do
    it '503のメンテナンスページが表示される' do
      FileUtils.touch(Constants::MAINTENANCE_DIR)
      visit login_path

      expect(page).to have_content '誠に申し訳ありません。ただいまメンテナンス中です。'
    end
  end

  describe 'メンテナンスファイルが存在しない場合' do
    it 'トップページが正常に表示される' do
      FileUtils.rm(Constants::MAINTENANCE_DIR)
      visit login_path

      expect(page).to have_content 'TODO App'
    end
  end
end
