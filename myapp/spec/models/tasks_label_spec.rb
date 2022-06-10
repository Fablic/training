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

  describe 'Dependent' do
    context 'task_idに紐づくTaskデータが削除された場合' do
      let!(:tasks) { create_list(:task, 2, :with_label, label_count: label_count) }

      context '削除対象Taskに対して、Labelが1つ設定されている場合' do
        let(:label_count) { 1 }

        it '紐づくTasksLabelデータが1件削除されること' do
          expect { tasks[0].destroy }.to change { TasksLabel.count }.by(-1)
          expect { TasksLabel.find_by!(task_id: tasks[0].id) }.to raise_error(ActiveRecord::RecordNotFound)
          expect { TasksLabel.find_by!(task_id: tasks[1].id) }.not_to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context '削除対象Taskに対して、Labelが2つ設定されている場合' do
        let(:label_count) { 2 }

        it '紐づくTasksLabelデータが2件削除されること' do
          expect { tasks[0].destroy }.to change { TasksLabel.count }.by(-2)
          expect { TasksLabel.find_by!(task_id: tasks[0].id) }.to raise_error(ActiveRecord::RecordNotFound)
          expect { TasksLabel.find_by!(task_id: tasks[1].id) }.not_to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'label_idに紐づくTaskデータが削除された場合' do
      context '削除対象Labelが、1つのTaskに設定されている場合' do
        let!(:tasks) { create_list(:task, 2, :with_label, label_count: 1) }

        it '紐づくTasksLabelデータが1件削除されること' do
          expect { Label.find(tasks[0].labels[0].id).destroy }.to change { TasksLabel.count }.by(-1)
          expect { TasksLabel.find_by!(task_id: tasks[0].id) }.to raise_error(ActiveRecord::RecordNotFound)
          expect { TasksLabel.find_by!(task_id: tasks[1].id) }.not_to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context '削除対象Labelが、2つのTaskに設定されている場合' do
        let!(:tasks) { create_list(:task, 2, :with_same_label) }

        it '紐づくTasksLabelデータが2件削除されること' do
          expect { Label.find(tasks[0].labels[0].id).destroy }.to change { TasksLabel.count }.by(-2)
          expect { TasksLabel.find_by!(task_id: tasks[0].id) }.to raise_error(ActiveRecord::RecordNotFound)
          expect { TasksLabel.find_by!(task_id: tasks[1].id) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'Userデータが削除されることによって、task_idに紐づくTaskデータが削除された場合' do
      let!(:tasks) { create_list(:task, 2, :with_label, label_count: 1) }

      it '紐づくTasksLabelデータが1件削除されること' do
        expect { User.find(tasks[0].user_id).destroy }.to change { TasksLabel.count }.by(-1)
        expect { TasksLabel.find_by!(task_id: tasks[0].id) }.to raise_error(ActiveRecord::RecordNotFound)
        expect { TasksLabel.find_by!(task_id: tasks[1].id) }.not_to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
