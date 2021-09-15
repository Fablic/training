require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task) { create(:task) }

  it 'expected attributes' do
    expect(task).to have_attributes(name: 'task 1', description: 'task 1 description')
  end

  it 'expected enum value' do
    expect(task.priority).to eq('low')
  end
end
