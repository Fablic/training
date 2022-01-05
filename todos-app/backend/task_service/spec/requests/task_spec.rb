# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  let(:valid_user_headers) do
    mock_token = JWT.encode({ user_id: 1, role: 'user' }, Rails.application.secrets.jwt_secret_key, 'HS256')
    { Authorization: "Bearer #{mock_token}" }
  end

  let(:valid_admin_headers) do
    mock_token = JWT.encode({ user_id: 1, role: 'admin' }, Rails.application.secrets.jwt_secret_key, 'HS256')
    { Authorization: "Bearer #{mock_token}" }
  end

  describe 'GET /tasks' do
    context 'when no task exists' do
      it 'returns empty list' do
        get '/tasks', headers: valid_user_headers, as: :json
        expect(response.status).to eq(200)
        json_object = JSON.parse(response.body)
        expect(json_object.length).to eq(0)
      end
    end

    context 'when one task exists' do
      it 'returns one task' do
        expected_task = create(:task)
        get '/tasks', headers: valid_user_headers, as: :json
        expect(response.status).to eq(200)
        json_object = JSON.parse(response.body)
        expect(json_object.length).to eq(1)
        actual_task = json_object.first
        expect(actual_task['id']).to eq(expected_task.id)
      end
    end

    context 'when multiple tasks exists' do
      context 'without sort param' do
        it 'returns all tasks sorted by id' do
          expected_tasks = create_list(:task, 5)
          get '/tasks', headers: valid_user_headers, as: :json
          expect(response.status).to eq(200)
          actual_tasks = JSON.parse(response.body)
          expect(actual_tasks.length).to eq(5)
          actual_tasks.each_with_index { |task, i| expect(task['id']).to eq(expected_tasks[i].id) }
        end
      end

      context 'with valid sort param' do
        it 'returns all tasks sorted by updated datetime' do
          task_1 = create(:task, updated_at: Date.new(2020, 1, 1))
          task_2 = create(:task, updated_at: Date.new(2020, 10, 1))
          task_3 = create(:task, updated_at: Date.new(2020, 3, 1))
          # get tasks ordered by updated datetime descending
          get '/tasks?sort=updated_at:desc', headers: valid_user_headers, as: :json
          expect(response.status).to eq(200)
          actual_tasks = JSON.parse(response.body)
          expect(actual_tasks.length).to eq(3)
          expect(actual_tasks[0]['id']).to eq(task_2.id)
          expect(actual_tasks[1]['id']).to eq(task_3.id)
          expect(actual_tasks[2]['id']).to eq(task_1.id)

          # get tasks ordered by updated datetime descending
          get '/tasks?sort=updated_at:asc', headers: valid_user_headers, as: :json
          expect(response.status).to eq(200)
          actual_tasks = JSON.parse(response.body)
          expect(actual_tasks.length).to eq(3)
          expect(actual_tasks[0]['id']).to eq(task_1.id)
          expect(actual_tasks[1]['id']).to eq(task_3.id)
          expect(actual_tasks[2]['id']).to eq(task_2.id)
        end

        it 'returns all tasks sorted by created datetime' do
          task_1 = create(:task, created_at: Date.new(2020, 1, 1))
          task_2 = create(:task, created_at: Date.new(2020, 10, 1))
          task_3 = create(:task, created_at: Date.new(2020, 3, 1))
          # get tasks ordered by created datetime descending
          get '/tasks?sort=created_at:desc', headers: valid_user_headers, as: :json
          expect(response.status).to eq(200)
          actual_tasks = JSON.parse(response.body)
          expect(actual_tasks.length).to eq(3)
          expect(actual_tasks[0]['id']).to eq(task_2.id)
          expect(actual_tasks[1]['id']).to eq(task_3.id)
          expect(actual_tasks[2]['id']).to eq(task_1.id)

          # get tasks ordered by created datetime ascending
          get '/tasks?sort=created_at:asc', headers: valid_user_headers, as: :json
          expect(response.status).to eq(200)
          actual_tasks = JSON.parse(response.body)
          expect(actual_tasks.length).to eq(3)
          expect(actual_tasks[0]['id']).to eq(task_1.id)
          expect(actual_tasks[1]['id']).to eq(task_3.id)
          expect(actual_tasks[2]['id']).to eq(task_2.id)
        end

        it 'returns all tasks sorted by due datetime' do
          task_1 = create(:task, due_datetime: Date.new(2020, 1, 1))
          task_2 = create(:task, due_datetime: Date.new(2020, 10, 1))
          task_3 = create(:task, due_datetime: Date.new(2020, 3, 1))
          task_4 = create(:task, due_datetime: nil)
          # get tasks ordered by due datetime descending
          get '/tasks?sort=due_datetime:desc', headers: valid_user_headers, as: :json
          expect(response.status).to eq(200)
          actual_tasks = JSON.parse(response.body)
          expect(actual_tasks.length).to eq(4)
          expect(actual_tasks[0]['id']).to eq(task_2.id)
          expect(actual_tasks[1]['id']).to eq(task_3.id)
          expect(actual_tasks[2]['id']).to eq(task_1.id)
          expect(actual_tasks[3]['id']).to eq(task_4.id)

          # get tasks ordered by due datetime ascending
          get '/tasks?sort=due_datetime:asc', headers: valid_user_headers, as: :json
          expect(response.status).to eq(200)
          actual_tasks = JSON.parse(response.body)
          expect(actual_tasks.length).to eq(4)
          expect(actual_tasks[0]['id']).to eq(task_4.id)
          expect(actual_tasks[1]['id']).to eq(task_1.id)
          expect(actual_tasks[2]['id']).to eq(task_3.id)
          expect(actual_tasks[3]['id']).to eq(task_2.id)
        end
      end

      context 'with invalid sort param' do
        it 'returns 400' do
          get '/tasks?sort=invalid_param:desc', headers: valid_user_headers, as: :json
          expect(response.status).to eq(400)
        end
      end

      context 'with valid status param' do
        it 'returns all tasks with the given status param' do
          task_1 = create(:task, status: 'not_started')
          task_2 = create(:task, status: 'in_progress')
          task_3 = create(:task, status: 'done')
          task_4 = create(:task, status: 'in_progress')
          get '/tasks?status=not_started', headers: valid_user_headers
          expect(response.status).to eq(200)
          expect(JSON.parse(response.body).length).to eq(1)
          expect(JSON.parse(response.body).first['status']).to eq('not_started')

          get '/tasks?status=in_progress', headers: valid_user_headers
          expect(response.status).to eq(200)
          expect(JSON.parse(response.body).length).to eq(2)
          expect(JSON.parse(response.body).first['status']).to eq('in_progress')
        end
      end

      context 'with invalid status param' do
        it 'returns 400' do
          get '/tasks?status=not_valid', headers: valid_user_headers
          expect(response.status).to eq(400)
        end
      end

      context 'with valid search param' do
        it 'returns tasks with a title that contains search param string' do
          task_1 = create(:task, title: 'hello world')
          task_2 = create(:task, title: 'holla world')
          task_3 = create(:task, title: 'bonjour world')

          get '/tasks?search=hello', headers: valid_user_headers, as: :json
          expect(response.status).to eq(200)
          expect(JSON.parse(response.body).length).to eq(1)
          expect(JSON.parse(response.body).first['id']).to eq(task_1.id)

          get '/tasks?search=bonjour', headers: valid_user_headers, as: :json
          expect(response.status).to eq(200)
          expect(JSON.parse(response.body).length).to eq(1)
          expect(JSON.parse(response.body).first['id']).to eq(task_3.id)

          get '/tasks?search=world', headers: valid_user_headers, as: :json
          expect(response.status).to eq(200)
          expect(JSON.parse(response.body).length).to eq(3)
        end
      end

      context 'with valid pagination params' do
        it 'returns tasks in correct chunks' do
          tasks = create_list(:task, 50)

          get '/tasks?offset=0&limit=20', headers: valid_user_headers, as: :json
          expect(response.status).to eq(200)
          returned_tasks = JSON.parse(response.body)
          expect(returned_tasks.length).to eq(20)
          expect(returned_tasks.first['id']).to eq(tasks.first.id)
          expect(returned_tasks.last['id']).to eq(tasks.at(19).id)

          get '/tasks?offset=35&limit=20', headers: valid_user_headers, as: :json
          expect(response.status).to eq(200)
          returned_tasks = JSON.parse(response.body)
          expect(returned_tasks.length).to eq(15)
          expect(returned_tasks.first['id']).to eq(tasks.at(35).id)
          expect(returned_tasks.last['id']).to eq(tasks.last.id)
        end
      end

      context 'with invalid pagination params' do
        it 'returns 400' do
          get '/tasks?offset=asb', headers: valid_user_headers, as: :json
          expect(response.status).to eq(400)

          get '/tasks?limit=fer', headers: valid_user_headers, as: :json
          expect(response.status).to eq(400)

          get '/tasks?offset=35&limit=qwer', headers: valid_user_headers, as: :json
          expect(response.status).to eq(400)
        end
      end

      context 'with valid user_id param' do
        context 'with admin JWT' do
          it 'returns tasks owned by the given user id' do
            create_list(:task, 5, user_id: 4)
            get '/tasks?user_id=4', headers: valid_admin_headers, as: :json
            expect(response.status).to eq(200)
            expect(JSON.parse(response.body).length).to eq(5)
          end
        end

        context 'with user JWT' do
          it 'returns 401' do
            get '/tasks?user_id=3', headers: valid_user_headers, as: :json
            expect(response.status).to eq(401)
          end
        end
      end
    end

    context 'without valid auth headers' do
      it 'return 401' do
        get '/tasks'
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'GET /tasks/:id' do
    context 'when target task exists' do
      it 'returns the target task' do
        expected_task = create(:task)
        get "/tasks/#{expected_task.id}", headers: valid_user_headers, as: :json
        expect(response.status).to eq(200)
        actual_task = JSON.parse(response.body)
        expect(actual_task['id']).to eq(expected_task.id)
        expect(actual_task['description']).to eq(expected_task.description)
      end
    end

    context "when target task doesn't exist" do
      it 'returns not found response' do
        get '/tasks/1', headers: valid_user_headers, as: :json
        expect(response.status).to eq(404)
      end
    end

    context 'without valid auth headers' do
      it 'return 401' do
        create(:task)
        get '/tasks/1'
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'POST /tasks' do
    context 'with valid request body' do
      it 'save to DB and return created' do
        post '/tasks', params: {
          task: {
            user_id: 1,
            title: 'test title',
            description: 'test description',
            priority: 0,
            status: 0,
            due_datetime: '2021-05-12 14:15:25',
          },
        }, headers: valid_user_headers, as: :json
        expect(response.status).to eq(201)
        expect(JSON.parse(response.body)['title']).to eq('test title')
        # Check DB
        expect(Task.count).to eq(1)
        expect(Task.last.title).to eq('test title')
      end
    end

    context 'with missing required attribute in the request body' do
      it 'returns 422' do
        post '/tasks', params: {
          task: {
            user_id: 1,
            # missing title
            description: 'test description',
            priority: 0,
            status: 0,
            due_datetime: '2021-05-12 14:15:25',
          },
        }, headers: valid_user_headers, as: :json
        expect(response.status).to eq(422)
      end
    end

    context 'with missing optional attribute in the request body' do
      it 'set default, save to DB and return created' do
        post '/tasks', params: {
          task: {
            user_id: 1,
            title: 'test title',
            # missing description
            priority: 0,
            # missing status
            # missing due_datetime
          },
        }, headers: valid_user_headers, as: :json
        expect(response.status).to eq(201)
        expect(JSON.parse(response.body)['description']).to be_nil
        expect(JSON.parse(response.body)['status']).to eq(Task.statuses.key(0))
        expect(Task.count).to eq(1)
        expect(Task.last.description).to be_nil
      end
    end

    context 'with invalid value in the request body' do
      it 'returns 422' do
        post '/tasks', params: {
          task: {
            user_id: 1,
            title: 'test title',
            description: 'test description',
            priority: 3, # must be either 0, 1 or 2
            status: 0,
            due_datetime: '2021-05-12 14:15:25',
          },
        }, headers: valid_user_headers, as: :json
        expect(response.status).to eq(422)
      end
    end

    context 'without valid auth headers' do
      it 'return 401' do
        post '/tasks', params: {
          task: {
            user_id: 1,
            title: 'test title',
            description: 'test description',
            priority: 3, # must be either 0, 1 or 2
            status: 0,
            due_datetime: '2021-05-12 14:15:25',
          },
        }
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'PUT/PATCH /tasks/:id' do
    context 'when target task exists and request has valid body' do
      it 'update DB and return updated task' do
        before_update = create(:task)
        patch "/tasks/#{before_update.id}", params: {
          task: {
            title: 'updated title',
          },
        }, headers: valid_user_headers, as: :json
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['title']).to eq('updated title')
        expect(Task.find(before_update.id).title).to eq('updated title')
      end
    end

    context "when target task doesn't exist and request has valid body" do
      it 'returns 404' do
        patch '/tasks/1', params: {
          task: {
            title: 'updated title',
          },
        }, headers: valid_user_headers, as: :json
        expect(response.status).to eq(404)
      end
    end

    context 'without valid auth headers' do
      it 'return 401' do
        before_update = create(:task)
        patch "/tasks/#{before_update.id}", params: {
          task: {
            title: 'updated title',
          },
        }
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'DELETE /tasks/:id' do
    context 'when target task exists' do
      it 'deletes task from DB and return 204' do
        task = create(:task)
        delete "/tasks/#{task.id}", headers: valid_user_headers, as: :json
        expect(response.status).to eq(204)
        expect { Task.find(task.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when target task doesn't exist" do
      it 'returns 404' do
        delete '/tasks/1', headers: valid_user_headers, as: :json
        expect(response.status).to be(404)
      end
    end

    context 'without valid auth headers' do
      it 'return 401' do
        task = create(:task)
        delete "/tasks/#{task.id}"
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'DELETE /tasks' do
    context 'when user_id param is given' do
      context 'with valid admin JWT' do
        it 'deletes tasks owned by the given user_id' do
          create_list(:task, 5, user_id: 3)
          delete '/tasks?user_id=3', headers: valid_admin_headers, as: :json
          expect(response.status).to be(204)
          expect(Task.where(user_id: 3)).to be_empty
        end
      end

      context 'without valid admin JWT' do
        it 'returns 401' do
          delete '/tasks?user_id=1'
          expect(response.status).to be(401)
        end
      end
    end

    context 'when user_id param is not given' do
      it 'returns 400' do
        delete '/tasks', headers: valid_user_headers, as: :json
        expect(response.status).to be(400)
      end
    end
  end
end
