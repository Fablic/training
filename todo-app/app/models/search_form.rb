# frozen_string_literal: true

class SearchForm
  include ActiveModel::Model
  attr_accessor :sort_direction, :status
end
