# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'tasks/index', type: :view do
  let(:user) { create(:user, name: 'kumaTaro') }
  let(:task_aqua) do
    create(:task,
           name: 'aqua',
           end_date: end_date_aqua,
           priority: 'high',
           status: 'untouched',
           explanation: 'aqua hara',
           user_id: user.id)
  end
  let(:task_kuma) do
    create(:task,
           name: 'kuma',
           end_date: end_date_kuma,
           priority: 'low',
           status: 'touched',
           explanation: 'brown kuma',
           user_id: user.id)
  end
  let(:end_date_aqua) { '2022/09/14 17:25' }
  let(:end_date_kuma) { '2022/09/13 18:25' }
  let(:tasks) { Kaminari.paginate_array([task_aqua, task_kuma]).page(1) }
  let(:label_a) { create(:label, name: 'ラベルA') }
  let(:label_b) { create(:label, name: 'ラベルB') }
  before do
    create(:task_label, task_id: task_aqua.id, label_id: label_a.id)
    create(:task_label, task_id: task_aqua.id, label_id: label_b.id)
  end

  before do
    assign(:tasks, tasks)
    assign(:labels, [label_a, label_b])
  end

  it 'renders a list of tasks' do
    render

    expect(rendered).to match(/ログアウトする/)

    expect(rendered).to match(/aqua/)
    expect(rendered).to match(/#{end_date_aqua}/)
    expect(rendered).to match(/高/)
    expect(rendered).to match(/未着手/)
    expect(rendered).to match(/aqua hara/)
    expect(rendered).to match(/ラベルA/)
    expect(rendered).to match(/ラベルB/)
    expect(rendered).to match(/kumaTaro/)

    expect(rendered).to match(/kuma/)
    expect(rendered).to match(/#{end_date_kuma}/)
    expect(rendered).to match(/低/)
    expect(rendered).to match(/着手中/)
    expect(rendered).to match(/brown kuma/)
    expect(rendered).to match(/kumaTaro/)
  end
end
