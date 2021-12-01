# frozen_string_literal: true

class Labelling < ApplicationRecord
  belongs_to :task
  belongs_to :label
end
