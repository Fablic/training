class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  scope :created, -> { order(deadline: :asc) }
  scope :updated, -> { order(deadline: :desc) }
end
