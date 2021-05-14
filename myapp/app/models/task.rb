class Task < ApplicationRecord
  # NOTE: Allow blank values `""` for :name and :description to let a user set empty task.
  #       I imagine like Google Keep, which allows us to create empty note.
  validates :name, exclusion: { in: [nil] }
  validates :description, exclusion: { in: [nil] }

  # NOTE: Set sporadic numbers in case new values are included in the future.
  enum priority: { low: 5, normal: 10, high: 20 }
  enum status: { waiting: 5, doing: 10, done: 20 }
end
