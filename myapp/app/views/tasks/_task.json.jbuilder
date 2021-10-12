json.extract! task, :id, :created_by, :name, :description, :started_at, :finished_at, :created_at, :updated_at
json.url task_url(task, format: :json)
