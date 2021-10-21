# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Task', type: :model do
  let(:title) { 'title for test' }
  let(:description) { 'description for test' }
  let(:due_date) { '2021-12-01 15:00:00' }
  let(:status) { 0 }
  let!(:task) { Task.new(title: title, description: description, due_date: due_date) }

  describe '#title' do
    context 'when less than or equal 50 charcters' do
      let(:title) { 't' * 50 }

      it 'is valid' do
        expect(task).to be_valid
      end
    end

    context 'when over 50 charcters' do
      let(:title) { 't' * 51 }

      it 'is invalid' do
        expect(task).not_to be_valid
      end
    end

    context 'when empty' do
      let(:title) { '' }

      it 'is invalid' do
        expect(task).not_to be_valid
      end
    end
  end

  describe '#description' do
    context 'when empty' do
      let(:descripton) { '' }

      it 'is valid' do
        expect(task).to be_valid
      end
    end

    context 'when less than or equal to 256 charcters' do
      let(:descripton) { 'd' * 255 }

      it 'is valid' do
        expect(task).to be_valid
      end
    end

    context 'when description over 255 charcter' do
      let(:description) { 'd' * 256 }

      it 'is invalid' do
        expect(task).not_to be_valid
      end
    end
  end

  describe '#due_date' do
    context 'when due_date type is string' do
      let(:due_date) { 'test' }

      it 'is invalid' do
        expect(task).not_to be_valid
      end
    end

    context 'when empty' do
      let(:due_date) { '' }

      it 'is invalid' do
        expect(task).not_to be_valid
      end
    end
  end

  describe 'status' do
    context 'when empty' do
      let(:status) { ' ' }

      it 'create succesfully' do
        expect(task).to be_valid
      end
    end
    context 'when string' do
      let(:due_date) { 'test' }

      it 'create faild' do
        expect(task).not_to be_valid
      end
    end
  end
end
