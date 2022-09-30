require 'rails_helper'

RSpec.describe Label, type: :model do
  before do
    @label = create(:label, :labels1)
  end

  it 'check label validates' do
    expect(@label).to be_valid

    @label = build(:label, name: '')
    expect(@label.valid?).to eq false
  end
end
