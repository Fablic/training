require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let!(:task_list) { create_list(:task, 10) }

  describe 'Top page' do
    before { visit root_path }

    it 'list view' do
      expect(page).to have_title 'Myapp'
      expect(page).to have_content(task_list.last.title)
    end
  end
end
