# frozen_string_literal: true

class Task < ApplicationRecord
  enum priority: {
    低: 25,
    中: 50,
    高: 75,
  }
end
