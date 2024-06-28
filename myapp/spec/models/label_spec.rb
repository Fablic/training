# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Label, type: :model do
  it 'is valid with a name' do
    label = Label.new(name: 'Urgent')
    expect(label).to be_valid
  end

  it 'is invalid without a name' do
    label = Label.new(name: nil)
    label.valid?
    expect(label.errors[:name]).to include('を入力してください')
  end

  it 'is invalid with a duplicate name' do
    Label.create(name: 'Urgent')
    label = Label.new(name: 'Urgent')
    label.valid?
    expect(label.errors[:name]).to include('はすでに存在します')
  end

  it 'has many tasks through task_labels' do
    association = described_class.reflect_on_association(:tasks)
    expect(association.macro).to eq :has_many
    expect(association.options[:through]).to eq :task_labels
  end
end
