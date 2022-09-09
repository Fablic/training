# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'tasks/index', type: :view do
  let!(:tasks) { create_list(:task, 4) }

  before(:each) do
    assign(:tasks, tasks)
  end

  it 'renders a list of tasks' do
    render

    tasks.each do |task|
      expect(rendered).to match(/#{task.name}/)
      expect(rendered).to match(/#{time_zone(task.end_date)}/)
      expect(rendered).to match(/#{Task.priorities_i18n[task.priority]}/)
      expect(rendered).to match(/#{Task.statuses_i18n[task.status]}/)
      expect(rendered).to match(/#{task.explanation}/)
    end
  end
end
