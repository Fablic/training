require 'rails_helper'

RSpec.describe 'Task Model(Post)', type: :model do
  let(:title) { 'title for test' }
  let(:description) { 'description for test' }
  let(:due_date) { '2021-12-01 15:00:00' }
  let!(:task) { Task.new(title: title, description: description, due_date: due_date) }

  describe 'Task' do
    context 'when valid input' do
      let(:title) { 't' * 49 }

      it 'created succesfully' do
        expect(task).to be_valid
      end

      it 'title string less than 50, created success' do
        expect(task).to be_valid
      end
    end

    context 'when invalid input' do

      let(:title) { '' }
      it 'title is empty, created faild' do
        expect(task).not_to be_valid
      end

      let(:title) { 't' * 50 }
      it 'title string over 50, created faild' do
        expect(task).not_to be_valid
      end

      let(:description) { 'd' * 255 }
      it 'description string over 255, created faild' do
        expect(task).not_to be_valid
      end

      let(:due_date) { '' }
      it 'due_date empty, created faild' do
        expect(task).not_to be_valid
      end
    end
  end
end
