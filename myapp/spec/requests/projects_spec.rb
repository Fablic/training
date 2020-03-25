# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Projects', type: :request do
  let(:headers) { { 'HTTP_USER_AGENT' => 'Chorme', 'REMOTE_ADDR' => '1.1.1.1' } }

  describe 'POST /projects/:id' do
    let!(:current_user) { create(:user) }
    before  do
      sign_in(current_user)
    end
    context 'Project creating is success' do
      it 'is creating 1 project and 4 Groups' do
        post projects_path, params: { project: { name: 'TEST1' } }, headers: headers
        expect(Project.count).to eq 1
        expect(Group.count).to eq 4
        expect(flash[:alert]).to eq 'Success to create project'
        expect(response.status).to eq 302
      end
    end

    context 'Project creating is failed because, did not put project name' do
      it 'could not create project and groups' do
        post projects_path, params: { project: { name: nil } }, headers: headers
        expect(Project.count).to eq 0
        expect(Group.count).to eq 0
        expect(flash[:alert]).to eq 'Failed to create project'
        expect(response.status).to eq 302
      end
    end
  end

  describe 'PATCH /projects/:id' do
    let!(:current_user) { create(:user) }
    let(:project) { create(:project) }
    let!(:user_project) { create(:user_project, user: current_user, project: project) }

    before  { sign_in(current_user) }
    context 'Update success' do
      it 'is changing project name to test1' do
        patch project_path(locale: 'en', id: project.id), params: { project: { name: 'test1' } }, headers: headers
        project.reload
        expect(project.name).to eq 'test1'
        expect(response).to be_successful
      end
    end

    context 'Project updating is failed because, did not put project name' do
      it 'could not change project name' do
        original_project_name = project.name

        patch project_path(locale: 'en', id: project.id), params: { project: { name: nil } }, headers: headers
        project.reload
        expect(project.name).to eq original_project_name
      end
    end
  end

  describe 'DELETE /projects/:id' do
    let!(:current_user) { create(:user) }
    let(:project) { create(:project) }
    let!(:user_project) { create(:user_project, user: current_user, project: project) }

    before  { sign_in(current_user) }
    context 'Project deleting is success' do
      it 'is deleting project and reference groups' do
        delete project_path(locale: 'en', id: project.id), headers: headers
        expect(Project.count).to eq 0
        expect(Group.count).to eq 0
        expect(flash[:alert]).to eq 'Success to destroy project'
        expect(response.status).to eq 302
      end
    end
  end
end
