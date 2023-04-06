require 'rails_helper'

RSpec.describe "labels/index", type: :view do
  before(:each) do
    assign(:labels, [
      Label.create!(),
      Label.create!()
    ])
  end

  it "renders a list of labels" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
  end
end
