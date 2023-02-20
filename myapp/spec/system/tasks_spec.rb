require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "a specification" do
    context "a context" do
      it "hoge" do
        expect('hoge').to eq 'hoge'
      end
    end
  end

end
