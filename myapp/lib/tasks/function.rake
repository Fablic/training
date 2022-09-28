namespace :function do
  desc '機能開始'
  task :start, ['id'] => :environment do |task, args|
    puts 'start-----------------'
    if args.id.nil?
      puts 'args not setting : must be set 1(create) or 2(update) or 3(delete) or 9(system)'
      puts 'end-------------------'
      next
    end
    function = Function.find(args.id.to_i)
    function.update(status: true)
    puts function.inspect
    puts 'end-------------------'
  end

  desc '機能停止'
  task :stop, ['id'] => :environment do |task, args|
    puts 'start-----------------'
    if args.id.nil?
      puts 'args not setting : must be set 1(create) or 2(update) or 3(delete) or 9(system)'
      puts 'end-------------------'
      next
    end
    function = Function.find(args.id.to_i)
    function.update(status: false)
    puts function.inspect
    puts 'end-------------------'
  end
end
