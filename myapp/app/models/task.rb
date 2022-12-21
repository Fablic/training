# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  description :string(255)      not null
#  due_date    :datetime         not null
#  priority    :integer
#  status      :integer
#  title       :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Task < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :due_date, presence: true
end
