# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Task Model(Post)', type: :model do
  let(:title) { 'title for test' }
  let(:description) { 'description for test' }
  let(:due_date) { '2021-12-01 15:00:00' }
  let!(:task) { Task.new(title: title, description: description, due_date: due_date) }

  describe 'Title' do
    context 'when less than or equal 50' do
      let(:title) { 't' * 50 }

      it 'create succesfully' do
        expect(task).to be_valid
      end
    end

    context 'when over 50 words' do
      let(:title) { 't' * 51 }

      it 'create faild' do
        expect(task).not_to be_valid
      end
    end

    context 'when empty' do
      let(:title) { '' }

      it 'create faild' do
        expect(task).not_to be_valid
      end
    end
  end

  describe 'description' do
    context 'when empty' do
      let(:descripton) { '' }

      it 'create success' do
        expect(task).to be_valid
      end
    end

    context 'when less than or equal to 256' do
      let(:descripton) { 'd' * 255 }

      it 'create success' do
        expect(task).to be_valid
      end
    end

    context 'when description over 255' do
      let(:description) { 'd' * 256 }

      it 'create faild' do
        expect(task).not_to be_valid
      end
    end
  end

  describe 'due_date' do
    context 'when due_date string' do
      let(:due_date) { 'test' }

      it 'create faild' do
        expect(task).not_to be_valid
      end
    end

    context 'when due_date empty' do
      let(:due_date) { '' }

      it 'create faild' do
        expect(task).not_to be_valid
      end
    end
  end
end
