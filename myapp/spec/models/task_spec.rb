require 'rails_helper'

RSpec.describe 'Task Model(Post)', type: :model do
  let(:title) { 'title for test' }
  let(:description) { 'description for test' }
  let!(:task) { Task.new(title: title, description: description) }

  describe 'Task' do
    context 'when valid input' do
      it 'created succesfully' do
        expect(task).to be_valid
      end
    end

    context 'when invalid input' do
      let(:title) { 'title' * 100 }
      it 'title is empty, created faild' do
        expect(task).not_to be_valid
      end

      let(:title) { 'title' * 100 }
      it 'title string over 50, created faild' do
        expect(task).not_to be_valid
      end

      let(:description) { 'description' * 1000 }
      it 'description string over 255, created faild' do
        expect(task).not_to be_valid
      end
    end
  end
end
