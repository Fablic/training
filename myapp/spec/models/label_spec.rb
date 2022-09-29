require 'rails_helper'

RSpec.describe Label, type: :model do
  before do
    @label = create(:label, :labels1)
  end

  it 'check task validates' do
    expect(@label).to be_valid

    @label = build(:task, title: '')
    expect(@label.valid?).to eq false
  end
end
