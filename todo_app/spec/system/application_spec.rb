# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Application', type: :system do
  describe 'エラーハンドリング' do
    it 'Routing Error' do
      visit '/hoge'

      expect(page).to have_content 'ご指定のページが見つかりませんでした。'
    end

    it 'Record Not Found Error' do
      visit task_path(0)

      expect(page).to have_content 'ご指定のページが見つかりませんでした。'
    end

    it '500 Error' do
      visit root_path

      allow_any_instance_of(ApplicationController).to receive(:render_500).and_raise StandardError
    end
  end
end
