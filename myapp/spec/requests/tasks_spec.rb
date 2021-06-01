require 'rails_helper'

RSpec.describe TasksController, type: :request do
  let(:user) { create(:user) }
  let(:task) { create(:task, user: user) }
  let(:labels) do
    {
      security: create(:label, name: 'security', user: user),
      bug: create(:label, name: 'bug', user: user),
      enhancement: create(:label, name: 'enhancement', user: user),
      special: create(:label, name: 'special', user: user),
    }
  end

  before do
    login_as user
  end

  describe 'POST /tasks' do
    it 'lets a user create a task' do
      expect { post '/tasks', params: { task: { name: 'A', description: 'A!', priority: :normal, status: :waiting } } }
        .to change { Task.count }.by(1)
      task = Task.find_by(name: 'A')
      expect(task).to be_valid
      expect(task.user).to eq user
    end

    it 'lets a user create a task with labels' do
      expect { post '/tasks', params: { task: { name: 'A', description: 'A!', priority: :normal, status: :waiting, labels: [labels[:security].id, labels[:special].id] } } }
        .to change { Task.count }.by(1).and change { TaskLabelAttachment.count }.by(2)
      task = Task.find_by(name: 'A')
      expect(task).to be_valid
      expect(task.user).to eq user
      expect(task.labels).to contain_exactly(labels[:security], labels[:special])
    end
  end

  describe 'PATCH /tasks/:id' do
    it 'lets a user edit a task' do
      expect { patch "/tasks/#{task.id}", params: { task: { name: 'Changed!' } } }
        .to change { task.reload.name }.to('Changed!')
    end

    it 'lets a user edit a task to add a label' do
      expect { patch "/tasks/#{task.id}", params: { task: { labels: [labels[:bug].id] } } }
        .to change { task.reload.labels.ids }.from([]).to([labels[:bug].id])
    end

    it 'lets a user edit a task to remove a label' do
      task.labels << [labels[:security], labels[:bug]]
      expect { patch "/tasks/#{task.id}", params: { task: { labels: [labels[:bug].id] } } }
        .to change { Set.new(task.reload.labels.ids) }.from(Set[labels[:security].id, labels[:bug].id])
                                                      .to(Set[labels[:bug].id])
    end

    it "disallows a user to edit another user's task" do
      another_user = create(:user)
      another_task = create(:task, user: another_user)
      expect { patch "/tasks/#{another_task.id}", params: { task: { name: 'Changed!' } } }
        .to not_change { task.reload.name }.and raise_error ActiveRecord::RecordNotFound
    end
  end

  describe 'DELETE /tasks/:id' do
    it 'lets a user delete a task' do
      task_id = task.id
      expect { delete "/tasks/#{task.id}" }.to change { Task.count }.by(-1)
      expect(Task.exists?(task_id)).to be false
    end

    it 'lets a user delete a task with labels' do
      task.labels << [labels[:special], labels[:bug]]
      task_id = task.id
      expect { delete "/tasks/#{task.id}" }.to change { Task.count }.by(-1).and change { TaskLabelAttachment.count }.by(-2)
      expect(Task.exists?(task_id)).to be false
      expect(labels[:special].tasks).to be_empty
      expect(labels[:bug].tasks).to be_empty
    end

    it "disallows a user to delete another user's task" do
      another_user = create(:user)
      another_task = create(:task, user: another_user)
      expect { delete "/tasks/#{another_task.id}" }.to not_change { Task.count }.and raise_error ActiveRecord::RecordNotFound
      expect(another_task).to be_persisted
    end
  end
end
