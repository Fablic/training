# == Schema Information
#
# Table name: tags
#
#  id         :integer          unsigned, not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Tag < ApplicationRecord
  has_many :taggings
  has_many :tasks, through: :taggings
end
