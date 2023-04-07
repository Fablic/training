require 'rails_helper'

RSpec.describe "task_labels/index", type: :view do
  before(:each) do
    assign(:task_labels, [
      TaskLabel.create!(),
      TaskLabel.create!()
    ])
  end

  it "renders a list of task_labels" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
  end
end
