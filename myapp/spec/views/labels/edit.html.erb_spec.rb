# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'labels/edit', type: :view do
  let!(:label) { assign(:label, create(:label)) }

  it 'renders the edit label form' do
    render

    assert_select 'form[action=?][method=?]', label_path(label), 'post' do
      assert_select 'input[name=?]', 'label[name]'
    end
  end
end
