class Task < ApplicationRecord
  enum priority: {
    low: 25,
    middle: 50,
    heigh: 75
  }
end
