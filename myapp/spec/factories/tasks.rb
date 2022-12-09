# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    title       { 'Spec' }
    description { 'test' }
    end_date    { Time.new(2022, 12, 7, 10, 30) }
  end
end
