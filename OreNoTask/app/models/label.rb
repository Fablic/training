class Label < ApplicationRecord
	scope :active, -> { where(deleted: 0) }
end
