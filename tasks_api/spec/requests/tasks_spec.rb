# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  describe 'GET /tasks' do
    before do
      FactoryBot.create_list(:task, 10)
    end

    it 'should return all Tasks' do
      expected = Task.all.order('created_at desc')
      get '/tasks.json'

      ret = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(ret.count).to eq Task.count
      expect(ret.map { |t| t['name'] }).to eq expected.map(&:name)
      expect(ret.map { |t| t['dueDate'] }).to eq(expected.map(&:due_date).map { |d| I18n.l(d) })
    end

    it 'should return tasks order by due date' do
      expected = Task.all.order(due_date: :asc)
      get '/tasks.json?order=due_date'

      ret = JSON.parse(response.body)
      expect(ret.map { |t| t['name'] }).to eq expected.map(&:name)
    end

    it 'should return tasks order by due date desc' do
      expected = Task.all.order(due_date: :desc)
      get '/tasks.json?order=due_date_desc'

      ret = JSON.parse(response.body)
      expect(ret.map { |t| t['name'] }).to eq expected.map(&:name)
    end
  end

  describe 'GET /task/ID.json' do
    before do
      @task = FactoryBot.create(:task)
    end

    it 'should return indicated Task' do
      get "/tasks/#{@task.id}.json"

      ret = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(ret['task']['name']).to eq @task.name
      expect(ret['task']['description']).to eq @task.description
    end

    it 'should return 404 when the Task is inexistent' do
      get '/tasks/0.json'
      expect(response.status).to eq 404
    end
  end

  describe 'POST /tasks.json' do
    before do
      @task = FactoryBot.attributes_for(:task)
    end

    it 'should create new Task' do
      post '/tasks.json',
           params: {
             task: @task,
           }

      ret = JSON.parse(response.body)
      expect(response.status).to eq 201
      expect(ret['task']['name']).to eq @task[:name]
      expect(ret['notice']).to eq 'New task has created.'
    end

    it "shouldn't create new Task without name" do
      post '/tasks.json',
           params: {
             task: @task.update({ name: nil }),
           }

      expect(response.status).to eq 422
    end

    it "shouldn't create new Task with blank name" do
      post '/tasks.json',
           params: {
             task: @task.update({ name: '' }),
           }

      expect(response.status).to eq 422
    end
  end

  describe 'PUT /tasks/ID.json' do
    before do
      @task = FactoryBot.create(:task)
    end

    it 'should update the Task' do
      new_name = 'new name'

      put "/tasks/#{@task.id}.json",
          params: { task: @task.attributes.update({ name: new_name }) }

      ret = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(ret['task']['name']).to eq new_name
      expect(ret['notice']).to eq 'The task has updated.'

      @task.reload
      expect(@task.name).to eq new_name
    end

    it "shouldn't update the Task without name" do
      put "/tasks/#{@task.id}.json",
          params: { task: @task.attributes.update({ name: nil }) }

      expect(response.status).to eq 422
    end

    it "shouldn't update the Task with blank name" do
      put "/tasks/#{@task.id}.json",
          params: { task: @task.attributes.update({ name: '' }) }

      expect(response.status).to eq 422
    end

    it 'should update the task with due date' do
      expected = '2021-07-21'
      put "/tasks/#{@task.id}.json",
          params: { task: @task.attributes.update({ due_date: expected }) }

      @task.reload
      expect(@task.due_date).to eq Date.parse(expected)
    end

    it 'should ignore invalid due dates' do
      put "/tasks/#{@task.id}.json",
          params: { task: @task.attributes.update({ due_date: 'hogehoge' }) }

      @task.reload
      expect(@task.due_date).to eq nil
    end
  end

  describe 'DELETE /tasks/ID.json' do
    before do
      @task = FactoryBot.create(:task)
    end

    it 'should delete the Task' do
      delete "/tasks/#{@task.id}.json"

      expect(response.status).to eq 200
      expect(Task.where(id: @task.id).count).to eq 0
      ret = JSON.parse(response.body)
      expect(ret['notice']).to eq 'The task has deleted.'
    end

    it 'shouldnt delete nonexistent Task' do
      delete '/tasks/0.json'

      expect(response.status).to eq 404
    end
  end
end
