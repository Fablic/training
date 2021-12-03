# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  let!(:user) { create(:user) }
  let(:task_name) { 'task_name for test' }
  let(:description) { 'description for test' }
  let(:status) { 'done' }
  let(:label) { 'label for test' }
  let(:start_date) { '2021-12-01 15:00:00' }
  let(:end_date) { '2021-12-31 15:00:00' }
  let(:task) { build(:task, task_name: task_name, description: description, status: status, label: label, start_date: start_date, end_date: end_date, user_id: user.id) }

  describe 'attribute: task_name' do
    context 'when less than or equal Max charcters' do
      let(:task_name) { 't' * 20 }

      it 'is valid' do
        expect(task).to be_valid
      end
    end

    context 'when over Max charcters' do
      let(:task_name) { 't' * 21 }

      it 'is invalid' do
        expect(task).to be_invalid
      end
    end

    context 'when empty' do
      let(:task_name) { '' }

      it 'is invalid' do
        expect(task).to be_invalid
      end
    end
  end

  describe 'description' do
    context 'when empty' do
      let(:descripton) { '' }

      it 'is valid' do
        expect(task).to be_valid
      end
    end

    context 'when less than or equal to Max charcters' do
      let(:descripton) { 'd' * 100 }

      it 'is valid' do
        expect(task).to be_valid
      end
    end

    context 'when description over Max charcter' do
      let(:description) { 'd' * 101 }

      it 'is invalid' do
        expect(task).to be_invalid
      end
    end
  end

  describe 'status' do
    context 'Value out of choice' do
      let(:status) { 'todo' }

      it 'create succesfully' do
        expect(task).to be_valid
      end
    end

    context 'Value out of choice' do
      let(:status) { 'test' }

      it 'create succesfully' do
        expect(task).to be_invalid
      end
    end
  end

  describe 'label' do
    context 'when less than or equal Max charcters' do
      let(:label) { 't' * 20 }

      it 'is valid' do
        expect(task).to be_valid
      end
    end

    context 'when over Max charcters' do
      let(:label) { 't' * 21 }

      it 'is invalid' do
        expect(task).to be_invalid
      end
    end
  end

  describe 'start_date' do
    context 'when start_date type is string.' do
      let(:start_date) { 'test' }

      it 'not invalid' do
        expect(task).to be_valid
      end
    end

    context 'set date' do
      let(:start_date) { '2021/01/01 11:00' }

      it 'correct date' do
        expect(task).to be_valid
      end
    end
  end

  describe 'end_date' do
    context 'when string' do
      let(:end_date) { 'test' }

      it 'is valid' do
        expect(task).to be_valid
      end
    end

    context 'set date' do
      let(:end_date) { '2022/01/01 11:00' }

      it 'correct date' do
        expect(task).to be_valid
      end
    end
  end

  describe 'start_date and end_date' do
    context 'only start_date' do
      let(:start_date) { '2021/11/11 11:00' }
      let(:end_date) { '' }

      it 'correct date' do
        expect(task).to be_valid
      end
    end

    context 'only end_date' do
      let(:start_date) { '' }
      let(:end_date) { '2021/01/01 11:00' }

      it 'correct date' do
        expect(task).to be_valid
      end
    end

    context 'more than end_date' do
      let(:start_date) { '2021/11/11 11:00' }
      let(:end_date) { '2021/01/01 11:00' }

      it 'invalid' do
        expect(task).to be_invalid
      end
    end

    context 'more than start_date' do
      let(:start_date) { '2021/11/11 11:00' }
      let(:end_date) { '2021/12/01 11:00' }

      it 'correct date' do
        expect(task).to be_valid
      end
    end
  end

end
