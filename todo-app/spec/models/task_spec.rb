# frozen_string_literal: true

require 'rails_helper'

describe Task, type: :model do
  it 'Validation success ' do
    app_user = FactoryBot.build(:app_user)
    task = FactoryBot.build(:task, app_user: app_user)

    expect(task).to be_valid
  end

  it 'Task name should not be empty ' do
    app_user = FactoryBot.build(:app_user)
    task = FactoryBot.build(:task, app_user: app_user)
    task.name = ''

    expect(task).not_to be_valid
  end

  it 'Task due_date should not be empty ' do
    app_user = FactoryBot.build(:app_user)
    task = FactoryBot.build(:task, app_user: app_user)
    task.due_date = nil

    expect(task).not_to be_valid
  end

  it 'Task status should be 0 to 2 ' do
    app_user = FactoryBot.build(:app_user)
    task = FactoryBot.build(:task, app_user: app_user)
    task.status = 3

    expect(task).not_to be_valid
  end

  it 'Search result should filter by status' do
    @app_user = FactoryBot.create(:app_user)
    @task1 = create(:task, name: 'task1', created_at: Time.zone.tomorrow, status: 1, app_user: @app_user)
    @task2 = create(:task, name: 'task2', created_at: Time.zone.yesterday, app_user: @app_user)
    @task3 = create(:task, name: 'task3', created_at: Time.zone.yesterday, app_user: @app_user)
    @task4 = create(:task, name: 'task4', created_at: Time.zone.yesterday, app_user: @app_user)
    @task5 = create(:task, name: 'task5', created_at: Time.zone.yesterday, app_user: @app_user)
    @task6 = create(:task, name: 'task6', created_at: Time.zone.yesterday, app_user: @app_user)
    @task7 = create(:task, name: 'task7', created_at: Time.zone.yesterday, app_user: @app_user)
    @task8 = create(:task, name: 'task8', created_at: Time.zone.yesterday, app_user: @app_user)
    @task9 = create(:task, name: 'task9', created_at: Time.zone.yesterday, app_user: @app_user)
    @task10 = create(:task, name: 'task10', created_at: Time.zone.yesterday, app_user: @app_user)
    @task11 = create(:task, name: 'task11', created_at: Time.zone.yesterday, app_user: @app_user)

    search_form = SearchForm.new({ sort_direction: 'desc' })

    tasks = Task.search_with_condition(search_form, 1, @app_user)

    expect(tasks.size).to be(10)

    tasks = Task.search_with_condition(search_form, 2, @app_user)

    expect(tasks.size).to be(1)

    search_form.status = 1
    tasks = Task.search_with_condition(search_form, 1, @app_user)

    expect(tasks.size).to be(1)

    tasks = Task.search_with_condition(search_form, 2, @app_user)

    expect(tasks).to be_empty
  end
end
