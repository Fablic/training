# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'tasks/show', type: :view do
  let!(:task) { create(:task) }

  before(:each) do
    @task = assign(:task, task)
  end

  it 'renders attributes in <p>' do
    render

    expect(rendered).to match(/#{task.name}/)
    expect(rendered).to match(/#{time_zone(task.end_date)}/)
    expect(rendered).to match(/#{task_priority_enum_to_ja(task.priority)}/)
    expect(rendered).to match(/#{task_status_enum_to_ja(task.status)}/)
    expect(rendered).to match(/#{task.explanation}/)
  end
end
