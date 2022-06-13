require 'rails_helper'

RSpec.describe TasksLabel, type: :model do
  let(:tasks_label) { create(:tasks_label) }

  describe 'Validation' do
    context 'task_idとlabel_idが存在する場合' do
      it '有効であること' do
        expect(tasks_label).to be_valid
      end
    end

    context 'task_idが存在しない場合' do
      it '無効であること' do
        tasks_label.task_id = nil
        expect(tasks_label).to be_invalid
      end
    end

    context 'label_idが存在しない場合' do
      it '無効であること' do
        tasks_label.label_id = nil
        expect(tasks_label).to be_invalid
      end
    end
  end
end
