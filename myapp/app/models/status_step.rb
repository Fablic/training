class StatusStep < ApplicationRecord
  belongs_to :from_status, foreign_key: 'from_status_id', class_name: 'Status'
  belongs_to :to_status, foreign_key: 'to_status_id', class_name: 'Status'
end
