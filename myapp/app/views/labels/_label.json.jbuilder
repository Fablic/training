# frozen_string_literal: true

json.extract! label, :id, :name, :color, :created_at, :updated_at
json.url label_url(label, format: :json)
