# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'visit /tasks/:id', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'shows a task' do
    task = Task.create(title: 'Existing Task', description: 'This is an existing task.', deadline: 2.days.from_now)
    visit task_path(task)

    expect(page).to have_content('Existing Task')
    expect(page).to have_content('This is an existing task.')
    expect(page).to have_content(task.deadline.strftime('%Y-%m-%d'))
  end
end
