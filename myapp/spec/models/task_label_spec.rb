# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaskLabel, type: :model do
  it 'belongs to a task' do
    association = described_class.reflect_on_association(:task)
    expect(association.macro).to eq :belongs_to
  end

  it 'belongs to a label' do
    association = described_class.reflect_on_association(:label)
    expect(association.macro).to eq :belongs_to
  end
end
