require 'rails_helper'

RSpec.describe Labelling, type: :model do
  before do
    create(:task, id: 1)
    create(:label, :labels1, id: 1)
    @labelling = create(:labelling)
  end

  it 'check labelling validates' do
    expect(@labelling).to be_valid

    @labelling = build(:labelling, task_id: '')
    expect(@labelling.valid?).to eq false

    @labelling = build(:labelling, label_id: '')
    expect(@labelling.valid?).to eq false
  end
end
