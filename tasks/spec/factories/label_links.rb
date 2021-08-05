FactoryBot.define do
  ActiveRecord::Base.connection.execute('ALTER TABLE label_links AUTO_INCREMENT = 1')
  factory :label_link, class: LabelLink do
    label_id { 1 }
    task_id { 1 }
  end
end
