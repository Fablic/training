require 'rails_helper'

RSpec.describe "controllers/edit", type: :view do
  let(:controller) {
    Controller.create!(
      Sessions: "MyString",
      new: "MyString"
    )
  }

  before(:each) do
    assign(:controller, controller)
  end

  it "renders the edit controller form" do
    render

    assert_select "form[action=?][method=?]", controller_path(controller), "post" do

      assert_select "input[name=?]", "controller[Sessions]"

      assert_select "input[name=?]", "controller[new]"
    end
  end
end
