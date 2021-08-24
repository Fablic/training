# frozen_string_literal: true

json.id task.id
json.name task.name
json.description task.description
json.dueDate task.due_date
json.status task.status
json.labels task.labels.map(&:value)
