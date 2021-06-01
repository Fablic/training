require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'nameとdescriptionが有効であること' do
    task = Task.new(
      name: 'タスク名',
      description: '詳細な説明'
    )
    expect(task).to be_valid
  end
end
