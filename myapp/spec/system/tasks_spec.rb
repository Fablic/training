# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Task', type: :system do
  context 'when user logged in' do
    let(:user) { create(:user) }
    let(:rspec_session) { {user_id: user.id} }
    let(:submit_button_text) { I18n.t('helpers.submit.submit', model: I18n.t('activerecord.models.task')).capitalize }

    describe '#index' do
      it 'displays a create task link' do
        create_task_button_text = I18n.t('helpers.submit.create', model: I18n.t('activerecord.models.task'))

        visit root_path

        expect(page).to have_link(create_task_button_text)
      end

      it 'displays a Search filter' do
        filter_task_button_text = I18n.t('form.filter_by')

        visit root_path

        expect(page).to have_button(filter_task_button_text)
      end

      describe 'pagination' do
        context 'when tasks displayed less than kaminari default_per_page' do
          before { create(:task, user: user) }
          let(:next_page_link) { 'Next' }

          it 'does not have pagination rendered' do
            visit root_path
            expect(page).not_to have_link(next_page_link)
          end
        end

        context 'when tasks displayed more than kaminari default_per_page' do
          before { create_list(:task, 11, user: user) }
          let(:next_page_link) { 'Next' }

          it 'does not have pagination rendered' do
            visit root_path
            expect(page).to have_link(next_page_link)
          end
        end
      end

      context 'when tasks already exist' do
        let!(:task_1) { create(:task, user: user) }
        let!(:task_2) { create(:task, user: user, title: 'Pick up mail', description: 'Go to postal office to pickup the arrived mails.') }

        it 'displays tasks infos' do
          visit root_path

          expect(page).to have_content task_1.title
          expect(page).to have_content task_1.description
          expect(page).to have_content task_1.due_date.strftime('%F')
          expect(page).to have_content task_1.user.name
          expect(page).to have_content task_2.title
          expect(page).to have_content task_2.description
          expect(page).to have_content task_2.due_date.strftime('%F')
          expect(page).to have_content task_2.user.name
        end

        context 'when tasks created by other user(s) exist' do
          let!(:task_created_by_others) { create(:task, title: 'Task created by other user') }

          it 'does not display tasks of other users' do
            visit root_path

            expect(page).not_to have_content task_created_by_others.title
          end
        end
      end

      context 'when sort tasks' do
        let!(:task_1) { create(:task, user: user, title: 'Task 1', due_date: 3.days.from_now) }
        let!(:task_2) { create(:task, user: user, title: 'Task 2', created_at: DateTime.now + 1, due_date: 2.days.from_now) }
        let(:sorted_tasks_ids) { page.all('.task-id').map(&:text).map(&:to_i) }

        context 'by default (no order_by params)' do
          it 'displays tasks with ascending ids' do
            visit root_path

            expect(sorted_tasks_ids).to eq([task_1.id, task_2.id])
          end
        end

        context 'by ID' do
          it 'displays tasks with ascending ids' do
            visit root_path
            page.find("#order_by option[value='id-asc']").select_option
            click_on 'Submit'

            expect(sorted_tasks_ids).to eq([task_1.id, task_2.id])
          end
        end

        context 'by Created At (Desc)' do
          it 'displays tasks with desending created_at' do
            visit root_path
            page.find("#order_by option[value='created_at-desc']").select_option
            click_on 'Submit'

            expect(sorted_tasks_ids).to eq([task_2.id, task_1.id])
          end
        end

        context 'by Due Date' do
          let!(:task_3) { create(:task, user: user, title: 'Task 3', due_date: 10.days.from_now) }

          describe 'sort DESC' do
            it 'displays tasks with desending due_date' do
              visit root_path
              page.find("#order_by option[value='due_date-desc']").select_option
              click_on 'Submit'

              expect(sorted_tasks_ids).to eq([task_3.id, task_1.id, task_2.id])
            end
          end

          describe 'sort ASC' do
            it 'displays tasks with ascending due_date' do
              visit root_path
              page.find("#order_by option[value='due_date-asc']").select_option
              click_on 'Submit'

              expect(sorted_tasks_ids).to eq([task_2.id, task_1.id, task_3.id])
            end
          end
        end
      end

      context 'when filter tasks' do
        let!(:task_1) { create(:task, :started, user: user, title: 'task 1') }
        let!(:task_2) { create(:task, :started, user: user, title: 'task 2 new') }
        let!(:task_3) { create(:task, user: user, title: 'task 3') }
        let(:filtered_tasks_ids) { page.all('.task-id').map(&:text).map(&:to_i) }

        it 'displays tasks with corresponding filter' do
          visit root_path
          fill_in 'search_title', with: 'new'
          page.find("#status_filter option[value='started']").select_option
          click_on 'Filter by'

          expect(filtered_tasks_ids).to eq([task_2.id])
        end
      end
    end

    describe '#new' do
      let(:new_task_description) { 'New task description' }
      let(:due_date) { Date.tomorrow }

      before { visit new_task_path }

      it 'displays form with fileds to be filled in' do
        expect(page).to have_content 'Title'
        expect(page).to have_content 'Description'
        expect(find_field('task_title').text).to be_blank
        expect(find_field('task_description').text).to be_blank
      end

      context 'when input necessary task columns' do
        it 'creates task successfully' do
          new_task_title = 'New task'
          new_task_description = 'New task description'

          fill_in 'task_title', with: new_task_title
          fill_in 'task_description', with: new_task_description
          select_date(field: 'task_due_date', date: due_date)

          expect { click_button(submit_button_text) }.to change(Task, :count).by(1)

          expect(page).to have_content new_task_title
          expect(page).to have_content new_task_description
          expect(page).to have_content due_date.strftime('%F')
        end
      end

      context 'when missing input necessary task column' do
        it 'does not create new task' do
          new_task_title = nil

          fill_in 'task_title', with: new_task_title
          fill_in 'task_description', with: new_task_description
          select_date(field: 'task_due_date', date: due_date)

          expect { click_button(submit_button_text) }.to change(Task, :count).by(0)

          error_message = "Title can't be blank"
          expect(page).to have_content error_message
        end
      end
    end

    describe '#show' do
      context 'when task presents' do
        let!(:task) { create(:task, user: user) }

        before { visit task_path(task) }

        it 'display the details of the task' do
          expect(page).to have_content task.id
          expect(page).to have_content task.title
          expect(page).to have_content task.description
          expect(page).to have_content task.due_date.strftime('%F')
          expect(page).to have_content task.created_at.strftime('%F %T')
          expect(page).to have_content task.user.name
        end

        it 'displays links to manipulate the task' do
          expect(page).to have_link 'Edit'
          expect(page).to have_link 'Delete'
          expect(page).to have_link 'Back'
        end

        describe 'task status related links' do
          context 'when task is unstarted' do
            it 'displays Mark Started button' do
              expect(page).to have_link 'Mark Started'
            end
          end

          context 'when task is started' do
            let!(:task) { create(:task, :started, user: user) }
            it 'displays Mark Completed button' do
              expect(page).to have_link 'Mark Completed'
            end
          end
        end
      end

      context 'when task not presents'  do
        it 'displays record not found error message' do
          task = create(:task, user: user)
          task.destroy!
          visit task_path(task)

          not_found_msg = "The page you were looking for doesn't exist."
          expect(page).to have_content(not_found_msg)
        end
      end
    end

    describe '#update' do
      let!(:task) { create(:task, user: user) }

      before { visit edit_task_path(task) }

      it 'display the details of the task' do
        expect(page).to have_field 'task_title', with: task.title
        expect(page).to have_field 'task_description', with: task.description
      end

      context 'when input necessary task columns' do
        it 'update task successfully' do
          updated_task_title = 'Updated task'
          updated_task_description = 'Updated task description'
          updated_due_date = 5.days.from_now

          fill_in 'task_title', with: updated_task_title
          fill_in 'task_description', with: updated_task_description
          select_date(field: 'task_due_date', date: updated_due_date)

          click_button(submit_button_text)

          expect(page).to have_content updated_task_title
          expect(page).to have_content updated_task_description
          expect(page).to have_content updated_due_date.strftime('%F')
        end
      end

      context 'when missing input necessary task column' do
        it 'does not update task' do
          updated_task_title = nil
          updated_task_description = 'Updated task description'

          fill_in 'task_title', with: updated_task_title
          fill_in 'task_description', with: updated_task_description

          click_button(submit_button_text)

          error_message = "Title can't be blank"
          expect(page).to have_content error_message
        end
      end
    end

    describe '#start' do
      let!(:task) { create(:task, user: user) }
      before { visit task_path(task) }

      context 'when update successfully' do
        it 'updates the task status to started' do
          click_link 'Mark Started'

          expect(page).to have_content 'started'
        end
      end

      context 'when update fails' do
        it 'does not update the task status' do
          task.destroy
          click_link 'Mark Started'

          expect(page).not_to have_content 'started'
        end
      end
    end

    describe '#complete' do
      let!(:task) { create(:task, :started, user: user) }
      before { visit task_path(task) }

      context 'when update successfully' do
        it 'updates the task status to completed' do
          click_link 'Mark Completed'

          expect(page).to have_content 'completed'
        end
      end

      context 'when update fails' do
        it 'does not update the task status' do
          task.update(status: 'unstarted')
          click_link 'Mark Completed'

          expect(page).not_to have_content 'completed'
        end
      end
    end

    describe '#destroy' do
      before do
        task = create(:task, user: user)
        visit task_path(task)
      end

      it 'destroys task successfully' do
        expect { click_link 'Delete' }.to change(Task, :count).by(-1)
      end
    end
  end

  context 'when internal server error occurs' do
    let(:user) { create(:user) }
    let(:rspec_session) { {user_id: user.id} }
    before { allow(TasksFinder).to receive(:new).and_raise(StandardError) }
    it 'display 500 error page' do
      visit root_path

      server_error_msg = "We're sorry, but something went wrong."
      expect(page).to have_content(server_error_msg)
    end
  end

  context 'when user not logged in' do
    it 'redirects to the login page' do
      visit root_path

      expect(page).to have_content('Sign Up or Log In')
    end
  end
end
