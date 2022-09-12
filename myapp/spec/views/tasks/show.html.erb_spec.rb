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
    expect(rendered).to match(/#{I18n.l(task.end_date)}/)
    expect(rendered).to match(/#{Task.priorities_i18n[task.priority]}/)
    expect(rendered).to match(/#{Task.statuses_i18n[task.status]}/)
    expect(rendered).to match(/#{task.explanation}/)
  end
end
