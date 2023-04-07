require 'rails_helper'

RSpec.describe "task_labels/show", type: :view do
  before(:each) do
    assign(:task_label, TaskLabel.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
