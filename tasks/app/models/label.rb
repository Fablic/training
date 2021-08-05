class Label < ApplicationRecord
  has_many :label_links, dependent: :destroy
  has_many :tasks, through: :label_links
end
