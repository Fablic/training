# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let!(:task1) do
    Task.create(title: 'Task 1', description: 'Description 1', created_at: 1.day.ago, deadline: 2.days.from_now)
  end
  let!(:task2) do
    Task.create(title: 'Task 2', description: 'Description 2', created_at: 2.days.ago, deadline: 1.day.from_now)
  end

  describe 'GET #index' do
    context 'when sorting by created_at ascending' do
      it 'returns tasks sorted by created_at in ascending order' do
        get :index, params: { sort_by: 'created_at', sort_direction: 'asc' }
        expect(assigns(:tasks)).to eq([task2, task1])
      end
    end

    context 'when sorting by created_at descending' do
      it 'returns tasks sorted by created_at in descending order' do
        get :index, params: { sort_by: 'created_at', sort_direction: 'desc' }
        expect(assigns(:tasks)).to eq([task1, task2])
      end
    end

    context 'when sorting by deadline ascending' do
      it 'returns tasks sorted by deadline in ascending order' do
        get :index, params: { sort_by: 'deadline', sort_direction: 'asc' }
        expect(assigns(:tasks)).to eq([task2, task1])
      end
    end

    context 'when sorting by deadline descending' do
      it 'returns tasks sorted by deadline in descending order' do
        get :index, params: { sort_by: 'deadline', sort_direction: 'desc' }
        expect(assigns(:tasks)).to eq([task1, task2])
      end
    end
  end
end
