require 'rails_helper'

RSpec.describe "task_labels/edit", type: :view do
  let(:task_label) {
    TaskLabel.create!()
  }

  before(:each) do
    assign(:task_label, task_label)
  end

  it "renders the edit task_label form" do
    render

    assert_select "form[action=?][method=?]", task_label_path(task_label), "post" do
    end
  end
end
