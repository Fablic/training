require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it 'should valid with some values' do
      task = Task.new(name: 'name', description: 'description')
      expect(task).to be_valid
    end

    it 'should reject blank names' do
      task = Task.new(name: '')
      expect(task.valid?).to be false
      expect(task.errors[:name]).to include("can't be blank")
    end
  end
end
