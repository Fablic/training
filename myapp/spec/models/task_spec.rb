# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'is valid with a title up to 50 characters' do
    task = Task.new(title: 'a' * 50, description: 'Valid Description')
    expect(task).to be_valid
  end

  it 'is not valid with a title over 50 characters' do
    task = Task.new(title: 'a' * 51)
    expect(task).not_to be_valid
  end

  it 'is valid with a long description up to 5000 characters' do
    task = Task.new(title: 'Valid Title', description: 'a' * 500)
    expect(task).to be_valid
  end

  it 'is not valid with a description over 5000 characters' do
    task = Task.new(title: 'Valid Title', description: 'a' * 501)
    expect(task).not_to be_valid
  end

  it 'is not valid without a title' do
    task = Task.new(title: nil)
    expect(task).not_to be_valid
  end

  it 'is valid without a description' do
    task = Task.new(title: 'Valid Title', description: nil)
    expect(task).to be_valid
  end
end
