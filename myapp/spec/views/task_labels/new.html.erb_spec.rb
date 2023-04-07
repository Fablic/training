require 'rails_helper'

RSpec.describe "task_labels/new", type: :view do
  before(:each) do
    assign(:task_label, TaskLabel.new())
  end

  it "renders new task_label form" do
    render

    assert_select "form[action=?][method=?]", task_labels_path, "post" do
    end
  end
end
