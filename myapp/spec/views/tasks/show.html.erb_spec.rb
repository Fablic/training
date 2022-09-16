# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'tasks/show', type: :view do
  let(:task) do
    create(:task,
           name: 'aqua',
           end_date:,
           priority: 'high',
           status: 'untouched',
           explanation: 'aqua hara')
  end
  let(:end_date) { '2022/09/14 17:25' }

  before { assign(:task, task) }

  it 'renders a task attributes' do
    render

    expect(rendered).to match(/aqua/)
    expect(rendered).to match(/#{end_date}/)
    expect(rendered).to match(/高/)
    expect(rendered).to match(/未着手/)
    expect(rendered).to match(/aqua hara/)
  end
end
