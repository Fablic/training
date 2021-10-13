FactoryBot.define do
  factory :task do
    title { 'TASK' }
    detail { 'DEATAIL' }
    priority { Task.prioritys[:low] }
    status { Task.statuses[:waiting] }    
    due_date { Time.zone.today }    
  end
end
