require 'rails_helper'

RSpec.describe TasksLabel, type: :model do
  let(:tasks_label) { create(:tasks_label) }

  describe 'Association' do
    let(:association) { described_class.reflect_on_association(target) }

    context '対Taskテーブルの場合' do
      let(:target) { :task }

      it '関連付けが「belongs_to」であること' do
        expect(association.class_name).to eq 'Task'
        expect(association.macro).to eq :belongs_to
      end
    end

    context '対Labelテーブルの場合' do
      let(:target) { :label }

      it '関連付けが「belongs_to」であること' do
        expect(association.class_name).to eq 'Label'
        expect(association.macro).to eq :belongs_to
      end
    end
  end

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
    let!(:users) { create_list(:user, 2) }
    let!(:labels) { create_list(:label, 2) }

    let!(:task01) { create(:task, user: users[0]) }
    let!(:tasks_label01) { create(:tasks_label, task_id: task01.id, label_id: labels[0].id) }

    let!(:task02) { create(:task, user: users[1]) }
    let!(:tasks_label02) { create(:tasks_label, task_id: task02.id, label_id: labels[1].id) }

    context 'task_idに紐づくTaskデータが削除された場合' do
      it '紐づくTasksLabelデータが削除されること' do
        expect { task01.destroy }.to change { TasksLabel.count }.by(-1)
        expect { TasksLabel.find_by!(task_id: task01.id) }.to raise_error(ActiveRecord::RecordNotFound)
        expect { TasksLabel.find_by!(task_id: task02.id) }.not_to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'label_idに紐づくTaskデータが削除された場合' do
      it '紐づくTasksLabelデータが削除されること' do
        expect { labels[0].destroy }.to change { TasksLabel.count }.by(-1)
        expect { TasksLabel.find_by!(task_id: task01.id) }.to raise_error(ActiveRecord::RecordNotFound)
        expect { TasksLabel.find_by!(task_id: task02.id) }.not_to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'Userデータが削除されることによって、task_idに紐づくTaskデータが削除された場合' do
      it '紐づくTasksLabelデータが削除されること' do
        expect { users[0].destroy }.to change { TasksLabel.count }.by(-1)
        expect { TasksLabel.find_by!(task_id: task01.id) }.to raise_error(ActiveRecord::RecordNotFound)
        expect { TasksLabel.find_by!(task_id: task02.id) }.not_to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
