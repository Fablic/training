class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  scope :latest, -> {order(deadline: :desc)}
end
