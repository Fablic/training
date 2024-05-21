require 'rails_helper'

RSpec.describe "Tasks", type: :model do
  describe 'Tasks validation test' do
    context 'valid task' do
      let!(:task) { Task.create(title: 'X'*255, description: 'Y'*30000) }
      it 'maximum task title and descrpition' do
        expect(task).to be_valid
      end
    end

    context 'title' do
      let!(:task_empty_title) { Task.create(title: '') }
      it 'empty title' do
        expect(task_empty_title).to_not be_valid
      end

      let!(:task_too_long_title) { Task.create(title: 'X'*256) }
      it 'too long title' do
        expect(task_too_long_title).to_not be_valid
      end
    end

    context 'description' do
      let!(:task_empty_description) { Task.create(title: 'X', description: '') }
      it 'empty title' do
        expect(task_empty_description).to be_valid
      end
      
      let!(:task_too_long_description) { Task.create(title: 'X', description: 'Y'*30001) }
      it 'too long description' do
        expect(task_too_long_description).to_not be_valid
      end
    end

  end
end
