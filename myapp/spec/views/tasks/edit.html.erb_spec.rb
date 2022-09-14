# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'tasks/edit', type: :view do
  let!(:task) { assign(:task, create(:task)) }

  it 'renders the edit task form' do
    render

    assert_select 'form[action=?][method=?]', task_path(task), 'post' do
      assert_select 'input[name=?]', 'task[name]'
      assert_select 'select[name=?]', 'task[priority]'
      assert_select 'select[name=?]', 'task[status]'
      assert_select 'textarea[name=?]', 'task[explanation]'
    end
  end
end
