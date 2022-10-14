# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'TaskLabels', type: :request do
  let!(:logined_user) { create(:user, role: 'admin') }
  before do
    post '/login', params: { session: { email: logined_user.email, password: logined_user.password } }
  end

  describe 'GET /new' do
    let(:task) { create(:task, name: 'task_a') }

    it 'renders a successful response' do
      get new_task_label_url + "?task_id=#{task.id}"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include 'label_ids[]'
    end
  end

  describe 'POST /attach_labels' do
    let(:task) { create(:task, name: 'task_a') }
    let(:label_a) { create(:label, name: 'label_a') }
    let(:label_b) { create(:label, name: 'label_b') }

    context 'with valid parameters' do
      let(:params) do
        { task_id: task.id, label_ids: [label_a, label_b] }
      end

      subject { post attach_labels_task_labels_url params: }

      it 'creates a new TaskLabel' do
        expect { subject }.to change(TaskLabel, :count).by(2)
      end

      it 'labeling correct TaskLabels' do
        subject
        expect(task.labels.map(&:name)).to match_array [label_a.name, label_b.name]
      end

      it 'redirects to the task attached labels' do
        subject
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to task_url(task)
      end
    end
  end
end
