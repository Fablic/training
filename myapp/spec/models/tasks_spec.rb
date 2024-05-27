require 'rails_helper'

RSpec.describe Task, type: :model do 
  describe 'validations for task' do 
    it 'is valid with all valid attributes' do
      task = Task.new(
          title: 'more than 5 chars',
          description: 'more than 10 chars',
          due: Time.zone.now + 5
      )

      expect(task).to be_valid
    end

    it 'is invalid with title less than 5 chars' do 
      task = Task.new(
        title: '< 5',
        description: 'more than 10 chars',
        due: Time.zone.now + 5
      )

      expect(task).to_not be_valid
    end

    it 'is invalid with title more than 30 chars' do 
      task = Task.new(
        title: 't' * 40,
        description: 'more than 10 chars',
        due: Time.zone.now + 5
      )

      expect(task).to_not be_valid
    end

    it 'is invalid with description less than 10 chars' do 
      task = Task.new(
        title: 'more than 5 chars',
        description: '< 10',
        due: Time.zone.now + 5
      )

      expect(task).to_not be_valid
    end

    it 'is invalid with description more than 300 chars' do 
      task = Task.new(
        title: 'more than 5 chars',
        description: 'd' * 301,
        due: Time.zone.now + 5
      )

      expect(task).to_not be_valid
    end

    it 'is invalid with empty due date' do 
      task = Task.new(
        title: 'more than 5 chars',
        description: 'more than 10 chars'
      )
      
      expect(task).to_not be_valid
    end

    it 'is invalid with due date earlier than now' do 
      task = Task.new(
        title: 'more than 5 chars',
        description: 'more than 10 chars',
        due: Time.zone.now - 60
      )
      
      expect(task).to_not be_valid
    end
  end
end
