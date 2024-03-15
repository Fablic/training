require 'rails_helper'

RSpec.describe "labels/new", type: :view do
  before(:each) do
    assign(:label, Label.new())
  end

  it "renders new label form" do
    render

    assert_select "form[action=?][method=?]", labels_path, "post" do
    end
  end
end
