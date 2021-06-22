require 'rails_helper'

RSpec.describe 'Tasks', type: :sytem do
  let!(:task) { create(:task, created_at: Faker::Time.backward) }
  let(:ja_title) { Task.human_attribute_name(:title) }
  let(:ja_desc) { Task.human_attribute_name(:description) }

  describe '#index' do
    let!(:task2) { create(:task, created_at: Faker::Time.forward) }

    it 'vist tasks/index' do
      visit root_path

      expect(current_path).to eq root_path

      expect(page).to have_content(task.title)
      expect(page).to have_content(task.description)
    end

    context 'not click created_at link' do
      it 'order created_at ASC' do
        visit root_path

        expect(page.body.index(task.title)).to be < page.body.index(task2.title)
      end
    end

    context 'click created_at link' do
      it 'order created_at DESC' do
        visit root_path
        click_link Task.human_attribute_name(:created_at)
  
        expect(page.body.index(task.title)).to be > page.body.index(task2.title)
      end
    end

    context 'send invalid paramter' do
      it 'order created_at ASC' do
        visit root_path(order: 'hoge')

        expect(page.body.index(task.title)).to be < page.body.index(task2.title)
      end
    end
  end

  describe '#new' do
    let!(:title) { Faker::Alphanumeric.alphanumeric(number: 10) }
    let!(:desc) { Faker::Alphanumeric.alphanumeric(number: 10) }

    context 'create task' do
      it 'success' do
        visit new_task_path

        fill_in ja_title, with: title
        fill_in ja_desc, with: desc

        expect do
          click_button I18n.t('common.action.create')
        end.to change(Task, :count).by(1)

        expect(current_path).to eq root_path

        expect(page).to have_content(I18n.t('tasks.flash.success.create'))
        expect(page).to have_content(title)
        expect(page).to have_content(desc)
      end
      it 'error' do
        visit new_task_path

        expect do
          click_button I18n.t('common.action.create')
        end.to change(Task, :count).by(0)

        expect(current_path).to eq tasks_path

        expect(page).to have_content(I18n.t('tasks.flash.error.create'))
        expect(page).to_not have_content(title)
        expect(page).to_not have_content(desc)
      end
    end
  end

  describe '#edit' do
    let!(:title) { Faker::Alphanumeric.alphanumeric(number: 10) }
    let!(:desc) { Faker::Alphanumeric.alphanumeric(number: 10) }

    context 'update task' do
      it 'success' do
        visit edit_task_path(task)

        expect(current_path).to eq edit_task_path(task)

        expect(page).to have_field ja_title, with: task.title
        expect(page).to have_field ja_desc, with: task.description

        fill_in ja_title, with: title
        fill_in ja_desc, with: desc

        expect do
          click_button I18n.t('common.action.update')
        end.to change(Task, :count).by(0)
  
        expect(current_path).to eq task_path(task)

        expect(page).to have_content(I18n.t('tasks.flash.success.update'))
        expect(page).to have_content(title)
        expect(page).to have_content(desc)
      end
      it 'errror' do
        visit edit_task_path(task)

        expect(current_path).to eq edit_task_path(task)

        expect(page).to have_field ja_title, with: task.title
        expect(page).to have_field ja_desc, with: task.description

        fill_in ja_title, with: nil
        fill_in ja_desc, with: nil

        expect do
          click_button I18n.t('common.action.update')
        end.to change(Task, :count).by(0)
  
        expect(current_path).to eq task_path(task)

        expect(page).to have_content(I18n.t('tasks.flash.error.update'))
        expect(page).to_not have_content(title)
        expect(page).to_not have_content(desc)
      end
    end
  end

  describe '#show' do
    it 'visit show' do
      visit task_path(task)

      expect(current_path).to eq task_path(task)

      expect(page).to have_content(task.title)
      expect(page).to have_content(task.description)
    end
  end

  describe '#destroy' do
    it 'delete record' do
      visit task_path(task)

      expect(current_path).to eq task_path(task)

      expect do
        click_link I18n.t('common.action.destroy')
      end.to change(Task, :count).by(-1)

      expect(current_path).to eq root_path

      expect(page).to have_content(I18n.t('tasks.flash.success.destroy'))
      expect(page).to_not have_content(task.title)
      expect(page).to_not have_content(task.description)
    end
  end
end
