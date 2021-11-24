require 'rails_helper'

RSpec.describe "labels/show", type: :view do
  before(:each) do
    @label = assign(:label, Label.create!(
      name: "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
