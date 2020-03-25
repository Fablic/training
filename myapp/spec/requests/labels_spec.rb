# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Labels', type: :request do
  let(:headers) { { 'HTTP_USER_AGENT' => 'Chorme', 'REMOTE_ADDR' => '1.1.1.1' } }
  describe 'PATCH /task_labels' do
    let(:project) { create(:project, :with_label) }
    let(:current_user) { create(:user) }

    before  { sign_in(current_user) }
    context 'Name and color of label is updateing success' do
      it 'is name and color changed ' do
        patch label_path(locale: 'en', id: project.labels.first.id), params: { label: { name: '難易度：上', color: 'red' } }, headers: headers
        expect(project.labels.first.name).to eq '難易度：上'
        expect(project.labels.first.color).to eq 'red'
      end
    end

    context 'Name and color of label is updateing failed, because id is not correct' do
      it 'is name and color changed ' do
        patch label_path(locale: 'en', id: 1000), params: { label: { name: '難易度：上', color: 'red' } }, headers: headers
        expect(project.labels.first.name).not_to eq '難易度：上'
        expect(project.labels.first.color).not_to eq 'red'
        expect(project.labels.first.name).to eq 'test group'
        expect(project.labels.first.color).to eq '#79BA5E'
      end
    end

    context 'Name and color of label is updateing failed, because color is null' do
      it 'is name and color changed ' do
        patch label_path(locale: 'en', id: project.labels.first.id), params: { label: { name: '難易度：上', color: nil } }, headers: headers
        expect(project.labels.first.name).not_to eq '難易度：上'
        expect(project.labels.first.color).not_to eq 'red'
        expect(project.labels.first.name).to eq 'test group'
        expect(project.labels.first.color).to eq '#79BA5E'
        expect(flash[:alert]).to eq 'Failed to update label'
      end
    end
  end
end
