# frozen_string_literal: true

class Label < ApplicationRecord
  validates :name, { presence: true, length: { maximum: 100 } }
  validates :color, { presence: true, length: { is: 7 } }
end
