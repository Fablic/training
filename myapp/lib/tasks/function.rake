namespace :function do
  desc '機能開始'
  task :start, ['id'] => :environment do |task, args|
    puts 'start-----------------'
    function = Function.find(args.id.to_i)
    function.update(status: true)
    puts function.inspect
    puts 'end-------------------'
  end

  desc '機能停止'
  task :stop, ['id'] => :environment do |task, args|
    puts 'start-----------------'
    function = Function.find(args.id.to_i)
    function.update(status: false)
    puts function.inspect
    puts 'end-------------------'
  end
end
