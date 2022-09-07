# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    title { 'MyString' }
    body { 'MyText' }
    finish_at { '1996/03/23' }
    status { 1 }
  end
end
