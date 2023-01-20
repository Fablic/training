# == Schema Information
#
# Table name: taggings
#
#  id         :integer          unsigned, not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tag_id     :integer          not null
#  task_id    :integer          not null
#
class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :task
end
