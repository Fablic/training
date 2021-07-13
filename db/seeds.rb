10.times do |n|
  Task.create!(
    name: "#{n + 1}つ目のタスク",
    description: "#{n + 1}日に\n何かをする",
  )
end
