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
        visit tasks_url
        expect(page).to have_content('test_title')
        expect(page).to have_content('低')
        expect(page).to have_content('未着手')
        expect(page).to have_content('test_kun')
      end
    end
  end
end
