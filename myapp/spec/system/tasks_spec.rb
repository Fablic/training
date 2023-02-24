require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  before do
    driven_by(:remote_chrome)
  end

  # TODO: バリデーションの実装は後で行うので、異常系のテストも後回し
  describe 'GET /' do
    it 'renders a successful response'do
      visit '/'
      expect(page).to have_content 'タスク 一覧'
    end
  end

end
