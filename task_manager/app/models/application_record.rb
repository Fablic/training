# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  def initialize(*)
    super
  rescue ArgumentError
    raise if valid?
  end
end
