require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user) { create(:user, name: 'test_kun') }
  describe 'GET /index' do
    
    context "When tasks and task.user_id data rendered" do
      let!(:task) do
        create(
          :task,
          title: 'test_title',
          description: 'this is test',
          priority: 'low',
          status: 'waiting',
          user_id: user.id
        )
      end
        it 'exist user name' do
          get(tasks_url)
          expect(response.body).to include 'test_title'
          expect(response.body).to include '低'
          expect(response.body).to include '未着手'
          expect(response.body).to include 'test_kun'
      end
    end
  end
end
