require 'rails_helper'

RSpec.describe "labels/show", type: :view do
  before(:each) do
    assign(:label, Label.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
