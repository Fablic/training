# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'tasks/index', type: :view do
  let!(:task_aqua) do
    create(:task,
           name: 'aqua',
           end_date: '2022/09/14 17:25',
           priority: 'high',
           status: 'untouched',
           explanation: 'aqua hara')
  end
  let!(:task_kuma) do
    create(:task,
           name: 'kuma',
           end_date: '2022/09/13 18:25',
           priority: 'low',
           status: 'touched',
           explanation: 'brown kuma')
  end
  let!(:tasks) { [task_aqua, task_kuma] }

  before { assign(:tasks, tasks) }

  it 'renders a list of tasks' do
    render

    end_date_aqua = '2022/09/14 17:25'
    end_date_kuma = '2022/09/13 18:25'

    expect(rendered).to match(/aqua/)
    expect(rendered).to match(/#{end_date_aqua}/)
    expect(rendered).to match(/高/)
    expect(rendered).to match(/未着手/)
    expect(rendered).to match(/aqua hara/)

    expect(rendered).to match(/kuma/)
    expect(rendered).to match(/#{end_date_kuma}/)
    expect(rendered).to match(/低/)
    expect(rendered).to match(/着手中/)
    expect(rendered).to match(/brown kuma/)
  end
end
