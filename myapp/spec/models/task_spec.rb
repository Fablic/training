# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  before do
    @task = create(:task)
  end

  it 'check task validates' do
    expect(@task).to be_valid

    @task = build(:task, title: '')
    expect(@task.valid?).to eq false

    @task = build(:task, body: '')
    expect(@task.valid?).to eq false

    @task = build(:task, finish_at: '')
    expect(@task.valid?).to eq false

    @task = build(:task, status: '')
    expect(@task.valid?).to eq false
  end
end
