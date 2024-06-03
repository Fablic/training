# frozen_string_literal: true

FactoryBot.define do
  factory :label1, class: Label do
    label { "label 1" }
  end
  factory :label2, class: Label do
    label { "label 2" }
  end
  factory :label3, class: Label do
    label { "label 3" }
  end
end
