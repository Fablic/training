# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'tasks/new', type: :view do
  let!(:task) { build(:task) }

  before(:each) do
    assign(:task, task)
  end

  it 'renders new task form' do
    render

    assert_select 'form[action=?][method=?]', tasks_path, 'post' do
      assert_select 'input[name=?]', 'task[name]'
      assert_select 'select[name=?]', 'task[priority]'
      assert_select 'select[name=?]', 'task[status]'
      assert_select 'textarea[name=?]', 'task[explanation]'
    end
  end
end
