require 'rails_helper'

RSpec.describe Task, type: :model do 
  describe 'validations for task' do 
    it 'is valid with all valid attributes' do
      task = Task.new(
          title: 'more than 5 chars',
          description: 'more than 10 chars',
          due: Time.zone.now + 5,
          status: 'pending'
      )

      expect(task).to be_valid
    end

    it 'is invalid with title less than 5 chars' do 
      task = Task.new(
        title: '< 5',
        description: 'more than 10 chars',
        due: Time.zone.now + 5,
        status: 'pending'
      )

      expect(task).to_not be_valid
    end

    it 'is invalid with title more than 30 chars' do 
      task = Task.new(
        title: 't' * 40,
        description: 'more than 10 chars',
        due: Time.zone.now + 5,
        status: 'pending'
      )

      expect(task).to_not be_valid
    end

    it 'is invalid with description less than 10 chars' do 
      task = Task.new(
        title: 'more than 5 chars',
        description: '< 10',
        due: Time.zone.now + 5,
        status: 'pending'
      )

      expect(task).to_not be_valid
    end

    it 'is invalid with description more than 300 chars' do 
      task = Task.new(
        title: 'more than 5 chars',
        description: 'd' * 301,
        due: Time.zone.now + 5,
        status: 'pending'
      )

      expect(task).to_not be_valid
    end

    it 'is invalid with empty due date' do 
      task = Task.new(
        title: 'more than 5 chars',
        description: 'more than 10 chars',
        status: 'pending'
      )
      
      expect(task).to_not be_valid
    end

    it 'is invalid with due date earlier than now' do 
      task = Task.new(
        title: 'more than 5 chars',
        description: 'more than 10 chars',
        due: Time.zone.now - 60,
        status: 'pending'
      )
      
      expect(task).to_not be_valid
    end

    it 'is invalid with no status specified' do 
      task = Task.new(
        title: 'title',
        description: 'description',
        due: Time.zone.now + 5
      )

      expect(task).to_not be_valid 
    end
  end

  describe 'class method' do 
    context '.search_with_sort' do 
      it 'when query_status is empty' do 
        task1 = Task.create!(
          title: 'Task 1',
          description: 'Description 1',
          due: Time.zone.now + 5,
          status: 'pending'
        )

        task2 = Task.create!(
          title: 'Task 2',
          description: 'Description 2',
          due: Time.zone.now + 10,
          status: 'in_progress'
        )

        task3 = Task.create!(
          title: 'No title',
          description: 'Description 3',
          due: Time.zone.now + 15,
          status: 'completed'
        )

        result = Task.search_with_sort('Task', '', 'created_at', 'desc')

        expect(result).to eq([task2, task1])
      end

      it 'when query_status is not empty' do 
        task1 = Task.create!(
          title: 'Task 1',
          description: 'Description 1',
          due: Time.zone.now + 5,
          status: 'pending'
        )

        task2 = Task.create!(
          title: 'Task 2',
          description: 'Description 2',
          due: Time.zone.now + 10,
          status: 'in_progress'
        )

        task3 = Task.create!(
          title: 'No title',
          description: 'Description 3',
          due: Time.zone.now + 15,
          status: 'completed'
        )

        result = Task.search_with_sort('Task', 'pending', 'created_at', 'desc')

        expect(result).to eq([task1])
      end

      it 'sort by created_at in desc order without title and status specified' do 
        task1 = Task.create!(
          title: 'Task 1',
          description: 'Description 1',
          due: Time.zone.now + 5,
          status: 'pending'
        )

        task2 = Task.create!(
          title: 'Task 2',
          description: 'Description 2',
          due: Time.zone.now + 10,
          status: 'in_progress'
        )

        task3 = Task.create!(
          title: 'No title',
          description: 'Description 3',
          due: Time.zone.now + 15,
          status: 'completed'
        )

        result = Task.search_with_sort('', '', 'created_at', 'desc')

        expect(result).to eq([task3, task2, task1])
      end

      it 'sort by created_at in asc order without title and status specified' do 
        task1 = Task.create!(
          title: 'Task 1',
          description: 'Description 1',
          due: Time.zone.now + 5,
          status: 'pending'
        )

        task2 = Task.create!(
          title: 'Task 2',
          description: 'Description 2',
          due: Time.zone.now + 10,
          status: 'in_progress'
        )

        task3 = Task.create!(
          title: 'No title',
          description: 'Description 3',
          due: Time.zone.now + 15,
          status: 'completed'
        )

        result = Task.search_with_sort('', '', 'created_at', 'asc')

        expect(result).to eq([task1, task2, task3])
      end

      it 'sort by due in desc order without title and status specified' do 
        task1 = Task.create!(
          title: 'Task 1',
          description: 'Description 1',
          due: Time.zone.now + 10,
          status: 'pending'
        )

        task2 = Task.create!(
          title: 'Task 2',
          description: 'Description 2',
          due: Time.zone.now + 1000,
          status: 'in_progress'
        )

        task3 = Task.create!(
          title: 'No title',
          description: 'Description 3',
          due: Time.zone.now + 100,
          status: 'completed'
        )

        result = Task.search_with_sort('', '', 'due', 'desc')

        expect(result).to eq([task2, task3, task1])
      end

      it 'sort by due in asc order without title and status specified' do 
        task1 = Task.create!(
          title: 'Task 1',
          description: 'Description 1',
          due: Time.zone.now + 10,
          status: 'pending'
        )

        task2 = Task.create!(
          title: 'Task 2',
          description: 'Description 2',
          due: Time.zone.now + 1000,
          status: 'in_progress'
        )

        task3 = Task.create!(
          title: 'No title',
          description: 'Description 3',
          due: Time.zone.now + 100,
          status: 'completed'
        )

        result = Task.search_with_sort('', '', 'due', 'asc')

        expect(result).to eq([task1, task3, task2])
      end
    end
  end
end
