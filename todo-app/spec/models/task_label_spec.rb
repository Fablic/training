# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaskLabel, type: :model do
  it 'Create new' do
    app_user = FactoryBot.build(:app_user)
    task = FactoryBot.build(:task, app_user: app_user)
    label = FactoryBot.build(:task_label, task: task)

    expect(label).to be_valid
  end

  it 'TaskLabel name should not be nil' do
    app_user = FactoryBot.build(:app_user)
    task = FactoryBot.build(:task, app_user: app_user)
    label = FactoryBot.build(:task_label, task: task)
    label.name = nil

    expect(label).not_to be_valid
  end

  it 'TaskLabel name should not be empty' do
    app_user = FactoryBot.build(:app_user)
    task = FactoryBot.build(:task, app_user: app_user)
    label = FactoryBot.build(:task_label, task: task)
    label.name = ''

    expect(label).not_to be_valid
  end

  it 'TaskLabel should belong to task' do
    label = FactoryBot.build(:task_label)

    expect(label).not_to be_valid
  end
end
