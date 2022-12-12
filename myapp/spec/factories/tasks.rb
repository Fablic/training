# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    title       { 'Spec' }
    description { 'test' }
  end
end
