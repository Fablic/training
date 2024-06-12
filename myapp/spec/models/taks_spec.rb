# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'Confirm default value' do
    task = Task.new
    expect(task.status).to eq(:open.to_s)
    expect(task.priority).to eq(:low.to_s)
  end
end
