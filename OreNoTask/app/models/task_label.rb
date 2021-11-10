class TaskLabel < ApplicationRecord
	# belongs_to :labels
	# belongs_to :tasks

	def self.get_labels(task_id)
      label_ids = where(task_id: task_id).pluck(:label_id)
      Label.where(id: label_ids)
    end
end
