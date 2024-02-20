require 'rails_helper'

RSpec.describe 'Task', type: :system do
  before do
    User.create!(id: 1, name: 'chris', email: 'chris@gmail', password: 'chrisLow2')
end

describe '#index' do
  before do
    visit root_path
  end

  context 'when user open this page' do
    it "display default item" do
        expect(page).to have_link 'Add Task'
      end

      it 'go to New Task page' do
        click_on 'Add Task'
        expect(current_path).to eq new_task_path
      end

      context 'when user has tasks' do
        before do
           Task.create!(name: 'Test', description: 'Testing of the website', user_id: 1)
          visit current_path
        end

        it "return user's task" do # rubocop:disable RSpec/MultipleExpectations
          expect(page).to have_link 'Test'
          expect(page).to have_link 'Edit'
          expect(page).to have_link 'Delete'
        end

      end

    end
end

describe '#show' do
  let(:task) {Task.create!(name: 'Test', description: 'Testing of the website', priority: 'Low', status: 'In Progress', Duedate: "2024-03-01".to_date, user_id: 1)}
  before do
    visit task_path(task)
  end

  it 'return task info' do # rubocop:disable RSpec/MultipleExpectations
    expect(page).to have_content task.name
    expect(page).to have_content task.description
    expect(page).to have_content task.status
    expect(page).to have_content task.priority
    expect(page).to have_content task.duedate
  end

  context 'when user click Edit' do
    it 'return edit task form' do
      click_on 'Edit'
      expect(current_path).to eq edit_task_path(task)
    end

  end

  context 'when user click Delete' do
    it 'display confirmation dialog' do
      click_on 'Delete'
      expect {
        expect(page.accept_confirm).to eq 'Do you want to delete #{task.name}?'
        expect(page).to have_content "delete success"
      }.to change {Task.count}.by(-1)
    end
  end


#   context 'when user click Home' do
#     it 'go to roog page' do
#       click_on 'Home'
#       expect(current_path).to eq root_path
# craftscat marked this conversation as resolved.
#     end
#   end

# end

describe '#new' do
  before do
    visit new_task_path
  end

  context 'when user go to this page' do
    it 'display blank task form' do # rubocop:disable RSpec/MultipleExpectations
      expect(page).to have_field 'Task title'
      expect(page).to have_field 'Description'
      expect(page).to have_field 'Status'
      expect(page).to have_field 'Priority'
      expect(page).to have_field 'DueDate'
    end
  end

end

describe '#edit' do
  let(:task) {Task.create!(name: 'Test', description: 'Testing of the website', priority: 'Low', status: 'Done', duedate: "2024-03-01".to_date, user_id: 1)}
  before do
    visit edit_task_path(task)
    puts current_path
  end

  context 'when user go to this page' do
    it 'display task form' do # rubocop:disable RSpec/MultipleExpectations
      expect(page).to have_field 'Task title', with: task.name
      expect(page).to have_field 'Description', with: task.description
      expect(page).to have_field 'Status', with: task.status
      expect(page).to have_field 'Priority', with: task.priority
      expect(page).to have_field 'Duedate', with: task.duedate
    end
  end
end

describe '#create' do
  before do
    visit new_task_path
    puts current_path
  end

  context 'when user go to Add task page' do
    it 'display brank form' do # rubocop:disable RSpec/MultipleExpectations
      expect(page).to have_field 'Task title'
      expect(page).to have_field 'Description'
      expect(page).to have_field 'Status'
      expect(page).to have_field 'Priority'
      expect(page).to have_field 'Duedate'
    end
  end

  context 'when user input task' do
    before do
      fill_in 'Task title', with: 'Test'
      fill_in 'Description', with: 'Testing of the website'
      select 'In Progress', from: 'Status'
      select 'Low', from: 'Priority'
      fill_in 'Duedate', with: '2024-03-01'
    end

    it 'display input task info' do # rubocop:disable RSpec/MultipleExpectations
      expect(page).to have_field 'Task title', with: 'Test'
      expect(page).to have_field 'Description', with: 'Testing of the website'
      expect(page).to have_field 'Duedate', with: '2024-03-01'
      expect(page).to have_field 'Status', with: 'In Progress'
      expect(page).to have_field 'Priority', with: 'Low'
    end

    context 'when user click "Create Task" button' do
      it 'go to Task detail page' do # rubocop:disable RSpec/MultipleExpectations
        click_on 'Create Task'
        expect(page).to have_content 'Test'
        expect(page).to have_content 'Testing of the website'
        expect(page).to have_content '2022-06-20'
        expect(page).to have_content 'In Progress'
        expect(page).to have_content 'Low'
      end
    end
  end

end

describe '#update' do
  let(:task) {Task.create!(name: 'Test', description: 'Testing of the website', priority: 'Low', status: 'In Progress', duedate: "2024-03-01".to_date, user_id: 1)}
  before do
    visit edit_task_path(task)
  end

  context 'when user edit task form' do
    before do
      fill_in 'Task title', with: 'Test2'
      fill_in 'Description', with: 'Testing2 of the website'
      select 'Done', from: 'Status'
      select 'Medium', from: 'Priority'
      fill_in 'Duedate', with: '2024-03-01'
    end

    it 'display new task info' do # rubocop:disable RSpec/MultipleExpectations
      expect(page).to have_field 'Task title', with: 'Test2'
      expect(page).to have_field 'Description', with: 'Testing2 of the website'
      expect(page).to have_field 'Status', with: 'Done'
      expect(page).to have_field 'Priority', with: 'Medium'
      expect(page).to have_field 'Duedate', with: '2024-03-01'
    end

    context 'when user click "Update Task" button' do
      it 'go to Task detail page' do # rubocop:disable RSpec/MultipleExpectations
        click_on 'Update Task'
        expect(page).to have_content 'Test'
        expect(page).to have_content 'Testing2 of the website'
        expect(page).to have_content 'Done'
        expect(page).to have_content 'Medium'
        expect(page).to have_content '2024-03-01'
      end
    end

  end

end

describe '#destroy' do
  let(:task) {Task.create!(name: 'Test', description: 'Testing of the website', priority: 'High', status: 'In Progress', Duedate: "2024-03-01".to_date, user_id: 1)}
  before do
    visit root_path
  end

  context 'when user click Delete' do

  end
end

end