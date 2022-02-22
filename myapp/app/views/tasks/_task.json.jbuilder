json.extract! task, :id, :task_name, :description, :status, :starts_on, :ends_on, :priority, :label, :created_at, :updated_at
json.url task_url(task, format: :json)
