# frozen_string_literal: true

FactoryBot.define do
  sequence :label_seq do |i|
    "label_#{i}"
  end

  factory :label, class: Label do
    created_by { 1 }
    name { generate :label_seq }
    color { '#777777' }
  end
end
