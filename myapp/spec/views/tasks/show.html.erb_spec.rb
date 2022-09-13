# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'tasks/show', type: :view do
  let!(:task) { assign(:task, create(:task)) }

  it 'renders a task attributes' do
    render

    expect(rendered).to match(/#{task.name}/)
    expect(rendered).to match(/#{time_zone(task.end_date)}/)
    expect(rendered).to match(/#{task.priority}/)
    expect(rendered).to match(/#{task.status}/)
    expect(rendered).to match(/#{task.explanation}/)
  end
end
