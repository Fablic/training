# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'deleting a user' do
    it 'deletes all associated tasks' do
      user = User.create!(name: 'test', email: 'user@example.com', password: 'password')
      user.tasks.create!(title: 'Task 1')
      user.tasks.create!(title: 'Task 2')

      expect { user.destroy }.to change { Task.count }.by(-2)
    end
  end
end