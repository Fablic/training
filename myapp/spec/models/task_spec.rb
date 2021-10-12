require 'rails_helper'

RSpec.describe 'Task Model(Post)', type: :model do
  let(:title) { 'title for test' }
  let(:description) { 'description for test' }
  let!(:task) { Task.new(title: title, description: description) }

  describe 'Task' do
    context 'title less than or equal to 50 words' do
      let(:title) { 't' * 50 }

      it 'create succesfully' do
        expect(task).to be_valid
      end
    end

    context 'description less than or equal to 256 words' do
      let(:descripton) { 'd' * 255 }

      it 'create success' do
        expect(task).to be_valid
      end
    end

    context 'title empty' do
      let(:title) { '' }

      it 'create faild' do
        expect(task).not_to be_valid
      end
    end

    context 'title over 50 words' do
      let(:title) { 't' * 51 }

      it 'create faild' do
        expect(task).not_to be_valid
      end
    end

    context 'description over 255 words' do
      let(:description)  { 'd' * 256 }

      it 'create faild' do
        expect(task).not_to be_valid
      end
    end
  end
end
