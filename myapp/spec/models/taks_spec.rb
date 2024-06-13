# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'Confirm default value' do
    task = Task.new
    expect(task.status).to eq(:open.to_s)
    expect(task.priority).to eq(:low.to_s)
  end

  describe 'Validation' do
    before do
      user = User.new
      @task = Task.new
      @task.user = user
      @task.title = 'title'
      @task.due_date = Date.today
    end

    it 'All attributes are OK' do
      expect(@task.valid?).to eq(true)
    end

    it 'title is empty' do
      @task.title = ''
      expect(@task.valid?).to eq(false)
    end

    it 'description is empty' do
      @task.description = ''
      expect(@task.valid?).to eq(true)
    end

    it 'due_date is empty' do
      @task.due_date = nil
      expect(@task.valid?).to eq(false)
    end
  end
end
