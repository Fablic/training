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
      allow_any_instance_of(TasksController).to receive(:index).and_throw(StandardError)
      visit root_path

      expect(page).to have_content '誠に申し訳ありません。ページに何らかのエラーが起きました。'
    end
  end
end
