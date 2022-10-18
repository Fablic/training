# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'labels/index', type: :view do
  let(:labels) do
    Kaminari.paginate_array(
      [
        create(:label, name: 'aqua'),
        create(:label, name: 'kuma')
      ]
    ).page(1)
  end

  before { assign(:labels, labels) }

  it 'renders a list of labels' do
    render

    expect(rendered).to match(/ログアウトする/)

    expect(rendered).to match(/aqua/)
    expect(rendered).to match(/kuma/)
  end
end
