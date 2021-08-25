# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  describe 'GET /tasks' do
    context 'with 101 tasks' do
      before do
        FactoryBot.create_list(:task, 101)
      end

      it 'should return 1st 25 Tasks' do
        expected = Task.all.order('created_at desc').limit(25)
        get '/tasks.json'

        ret = JSON.parse(response.body)
        expect(response.status).to eq 200

        tasks = ret['tasks']
        expect(tasks.count).to eq expected.count
        expect(tasks.map { |t| t['name'] }).to eq expected.map(&:name)
        expect(tasks.map { |t| t['dueDate'] }).to eq(expected.map(&:due_date).map { |d| I18n.l(d) })
        expect(tasks.map { |t| t['status'] }).to eq(expected.map(&:status))

        meta = ret['meta']
        expect(meta['totalPages']).to eq 5
        expect(meta['currentPage']).to eq 1
      end

      it 'should return 3rd page' do
        expected = Task.all.order('created_at desc').limit(25).offset(25 * 2)
        get '/tasks.json?page=3'

        ret = JSON.parse(response.body)
        tasks = ret['tasks']
        expect(response.status).to eq 200
        expect(tasks.count).to eq expected.count
        expect(tasks.map { |t| t['name'] }).to eq expected.map(&:name)

        meta = ret['meta']
        expect(meta['currentPage']).to eq 3
      end

      it 'should return tasks order by due date' do
        expected = Task.all.order(due_date: :asc).limit(25)
        get '/tasks.json?order=due_date'

        ret = JSON.parse(response.body)
        expect(ret['tasks'].map { |t| t['name'] }).to eq expected.map(&:name)
      end

      it 'should return tasks order by due date desc' do
        expected = Task.all.order(due_date: :desc).limit(25)
        get '/tasks.json?order=due_date_desc'

        ret = JSON.parse(response.body)
        expect(ret['tasks'].map { |t| t['name'] }).to eq expected.map(&:name)
      end

      describe 'full text search', cleaner: :truncation do
        let (:targets) { Task.all.order('rand()').limit(3) }
        before do
          targets.map { |t| t.update(name: "#{t.name} keyword") }
        end

        it 'should return tasks which have search keywords' do
          expected = targets.sort { |a, b| b.created_at <=> a.created_at }.map(&:name)
          get '/tasks.json?q=keyword'

          ret = JSON.parse(response.body)
          expect(ret['tasks'].map { |t| t['name'] }).to eq expected
        end

        it 'should return filtered tasks order by due date desc' do
          expected = targets.sort { |a, b| b.due_date <=> a.due_date }.map(&:name)
          get '/tasks.json?q=keyword&order=due_date_desc'

          ret = JSON.parse(response.body)
          expect(ret['tasks'].map { |t| t['name'] }).to eq expected
        end
      end

      describe 'state search' do
        %i[in_progress close].each do |s|
          let (:targets) { Task.all.order('rand()').limit(3) }

          it "should return tasks with status=#{s}" do
            targets.map { |t| t.update(status: s) }
            expected = targets.sort { |a, b| b.created_at <=> a.created_at }.map(&:name)
            get "/tasks.json?status=#{s}"

            ret = JSON.parse(response.body)
            expect(ret['tasks'].map { |t| t['name'] }).to eq expected
          end
        end
      end

      describe 'maintenance' do
        it 'should return 503 when therere maintenace object' do
          FactoryBot.create(:maintenance)
          get '/tasks.json'

          expect(response.status).to eq 503
          ret = JSON.parse(response.body)
          expect(ret['type']).to eq 'under_maintenance'
        end
      end
    end

    describe 'labels' do
      it 'should return the task with labels' do
        expected = FactoryBot.create(:task, :with_labels)
        get '/tasks.json'

        ret = JSON.parse(response.body)
        actual = ret['tasks'].first

        expect(actual['labels']).to eq expected.labels.map(&:value)
      end

      it 'should return tasks with specified label' do
        label = FactoryBot.create(:label)
        tasks = FactoryBot.create_list(:task, 10)
        tasks.each { |t| t.labels << label }

        get "/tasks.json?label=#{label.value}"
        ret = JSON.parse(response.body)
        actual = ret['tasks'].map { |t| t['name'] }

        expect(actual.sort).to eq tasks.map(&:name).sort
      end
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

    describe 'labels' do
      it 'should put new labels' do
        expected = %w[newlabel1 newlabel2]
        put "/tasks/#{@task.id}.json",
            params: { task: @task.attributes.update({ labels: expected }) }

        @task.reload
        expect(@task.labels.map(&:value)).to eq expected
      end

      it 'should do nothing with existing labels' do
        actual = FactoryBot.create(:task, :with_labels)
        expected = actual.labels.map(&:value)
        put "/tasks/#{actual.id}.json",
            params: { task: actual.attributes.update({ labels: expected }) }

        actual.reload
        expect(actual.labels.map(&:value)).to eq expected
      end

      it 'should remove the label from the task' do
        actual = FactoryBot.create(:task, :with_labels)
        expected = actual.labels.map(&:value).tap(&:pop)

        put "/tasks/#{actual.id}.json",
            params: { task: actual.attributes.update({ labels: expected }) }

        actual.reload
        expect(actual.labels.map(&:value)).to eq expected
      end

      it 'should remove the label when it became usused' do
        actual = FactoryBot.create(:task, :with_labels)
        labels = actual.labels

        put "/tasks/#{actual.id}.json",
            params: { task: actual.attributes.update({ labels: [] }) }

        labels.each { |label| expect { label.reload }.to raise_error(ActiveRecord::RecordNotFound) }
      end
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
