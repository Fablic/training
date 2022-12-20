# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Task', type: :system do
  let(:submit_button_text) { I18n.t('helpers.submit.submit', model: I18n.t('activerecord.models.task')).capitalize }

    describe '#index' do
      it 'displays a create task link' do
        create_task_botton_text = I18n.t('helpers.submit.create', model: I18n.t('activerecord.models.task'))

        visit root_path

        expect(page).to have_link(create_task_botton_text)
      end

      context 'when tasks already exist' do
        let!(:task_1) { create(:task) }
        let!(:task_2) { create(:task, title: 'Pick up mail', description: 'Go to postal office to pickup the arrived mails.') }

        it 'displays tasks infos' do
          visit root_path

          expect(page).to have_content task_1.title
          expect(page).to have_content task_1.description
          expect(page).to have_content task_2.title
          expect(page).to have_content task_2.description
        end
      end

      context 'when sort tasks' do
        let!(:task_1) { create(:task, title: 'Task 1') }
        let!(:task_2) { create(:task, title: 'Task 2', created_at: DateTime.now + 1) }
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
      end
    end

    describe '#new' do
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

          expect { click_button(submit_button_text) }.to change(Task, :count).by(1)

          expect(page).to have_content new_task_title
          expect(page).to have_content new_task_description
        end
      end

      context 'when missing input necessary task column' do
        it 'does not create new task' do
          new_task_title = nil
          new_task_description = 'New task description'

          fill_in 'task_title', with: new_task_title
          fill_in 'task_description', with: new_task_description

          expect { click_button(submit_button_text) }.to change(Task, :count).by(0)

          error_message = "Title can't be blank"
          expect(page).to have_content error_message
        end
      end
    end

    describe '#show' do
      context 'when task presents' do
        let!(:task) { create(:task) }

        before { visit task_path(task) }

        it 'display the details of the task' do
          expect(page).to have_content task.title
          expect(page).to have_content task.description
        end

        it 'displays links to manipulate the task' do
          expect(page).to have_link 'Edit'
          expect(page).to have_link 'Delete'
          expect(page).to have_link 'Back'
        end
      end

      context 'when task not presents'  do
        it 'displays record not found error message' do
          task = create(:task)
          task.destroy!
          visit task_path(task)

          not_found_msg = "The page you were looking for doesn't exist."
          expect(page).to have_content(not_found_msg)
        end
      end
    end

    describe '#update' do
      let!(:task) { create(:task) }
      before { visit edit_task_path(task) }

      it 'display the details of the task' do
        expect(page).to have_field 'task_title', with: task.title
        expect(page).to have_field 'task_description', with: task.description
      end

      context 'when input necessary task columns' do
        it 'update task successfully' do
          updated_task_title = 'Updated task'
          updated_task_description = 'Updated task description'

          fill_in 'task_title', with: updated_task_title
          fill_in 'task_description', with: updated_task_description

          click_button(submit_button_text)

          expect(page).to have_content updated_task_title
          expect(page).to have_content updated_task_description
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

    describe '#destroy' do
      before do
        task = create(:task)
        visit task_path(task)
      end

      it 'destroys task successfully' do
        expect { click_link 'Delete' }.to change(Task, :count).by(-1)
      end
    end
  end

  context 'when internal server error occurs' do
    before { allow(Task).to receive(:all).and_raise(StandardError) }
    it 'display 500 error page' do
      visit root_path

      server_error_msg = "We're sorry, but something went wrong."
      expect(page).to have_content(server_error_msg)
    end
end
