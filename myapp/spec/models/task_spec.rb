# frozen_string_literal: true

require 'rails_helper'

describe Task, type: :model do
  it 'is invalid without name' do
    task = described_class.new(name: nil)
    expect(task).not_to be_valid
  end

  it 'is invalid with too long name' do
    task = described_class.new(name: 'a' * 51)
    expect(task).not_to be_valid
  end

  it 'is valid with name' do
    task = described_class.new(name: 'task')
    expect(task).to be_valid
  end

  it 'is valid with name of 50 letters' do
    task = described_class.new(name: 'a' * 50)
    expect(task).to be_valid
  end
end
