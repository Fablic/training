# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'TaskLabels', type: :request do
  let(:headers) { { 'HTTP_USER_AGENT' => 'Chorme', 'REMOTE_ADDR' => '1.1.1.1' } }

  describe 'POST /task_labels' do
    let(:project) { create(:project, :with_group_and_label) }
    let(:task) { create(:task, group: project.groups.first) }
    let(:current_user) { create(:user) }

    before  { sign_in(current_user) }
    context 'Registering label to task is success' do
      it 'is adding task_labels recorder' do
        post task_labels_path, params: { task_label: { task_id: task.id, label_id: project.labels.first.id } }, headers: headers
        expect(TaskLabel.count).to eq 1
        expect(task.labels.count).to eq 1
      end
    end

    context 'Registering label to task is failed, because label id is not correct' do
      it 'could not add task_labels recorder' do
        post task_labels_path, params: { task_label: { task_id: task.id, label_id: 100 } }, headers: headers
        expect(TaskLabel.count).to eq 0
        expect(task.labels.count).to eq 0
        expect(response.status).to eq 404
      end
    end

    context 'Registering label to task is failed, because task id is not correct' do
      it 'could not add task_labels recorder' do
        post task_labels_path, params: { task_label: { task_id: 100, label_id: project.labels.first.id } }, headers: headers
        expect(TaskLabel.count).to eq 0
        expect(task.labels.count).to eq 0
        expect(response.status).to eq 404
      end
    end
  end

  describe 'DELETE /task_labels' do
    let(:project) { create(:project, :with_group_and_label) }
    let(:task) { create(:task, group: project.groups.first) }
    let(:current_user) { create(:user) }

    before  { sign_in(current_user) }
    context 'removing label to task is success' do
      it 'is removing task_labels recorder' do
        delete task_labels_path, params: { task_label: { task_id: task.id, label_id: project.labels.first.id } }, headers: headers
        expect(TaskLabel.count).to eq 0
        expect(task.labels.count).to eq 0
      end
    end
  end
end
