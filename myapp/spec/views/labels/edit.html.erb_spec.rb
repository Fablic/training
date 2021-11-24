require 'rails_helper'

RSpec.describe "labels/edit", type: :view do
  before(:each) do
    @label = assign(:label, Label.create!(
      name: "MyString"
    ))
  end

  it "renders the edit label form" do
    render

    assert_select "form[action=?][method=?]", label_path(@label), "post" do

      assert_select "input[name=?]", "label[name]"
    end
  end
end
