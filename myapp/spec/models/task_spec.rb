require 'rails_helper'

RSpec.describe 'Task Model(Post)', type: :model do
  let!(:title) { 'title for test' }
  let!(:description) { 'description for test' }
  let!(:task) { Task.new(title: title, description: description) }

  describe 'Validation correct format' do
    context 'title' do
      it 'title-no_empty-within_length' do
        expect(task).to be_valid
      end
    end

    context 'description' do
      it 'description-empty' do
        expect(task).to be_valid
      end

      it 'description-within_length-no_empty' do
        expect(task).to be_valid
      end
    end
    # for step11
    # context 'due_date' do
    # it 'du_date' do
    # end
    # end
  end

  describe 'Validation incorrect format' do
    context 'title' do
      let(:title) { '' }
      let(:title) { 'title' * 100 }
      let(:title) { 'title' * 100 }

      it 'title-empty' do
        expect(task).not_to be_valid
      end

      it 'title-over_length' do
        expect(task).not_to be_valid
      end
    end

    context 'description' do
      let(:description) { 'description' * 1000 }

      it 'description_over-length' do
        expect(task).not_to be_valid
      end
    end
    # for step11
    # context 'due_date' do
    #   it 'du_date-past_date' do
    #   end
    #   it 'du_date-incorrect_date_format' do
    #   end
    # end
  end
end
