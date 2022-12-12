# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  title       :string(255)
#  description :string(255)
#  priority    :integer
#  status      :integer
#  due_date    :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Task < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
end
