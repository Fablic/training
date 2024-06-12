class TaskLabel < ApplicationRecord # rubocop:disable Style/Documentation
  belongs_to :task
  belongs_to :label
end
