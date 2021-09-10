# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Errors', type: :system do
  describe 'Enter Maintainance Mode' do
    before {
      file = File.open('./config/maintanance.txt', 'w')
      file.puts( 'システムメンテナンスのため' )
      file.close
      visit root_path
    }
    after{
      File.delete( './config/maintanance.txt' )
    }
    it 'メンテナンス画面が表示される' do
      expect(page).to have_content 'メンテナンス中です'
      expect(page).to have_content 'システムメンテナンスのため'
    end
  end
end
