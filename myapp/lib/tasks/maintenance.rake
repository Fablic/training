def maintenance(mode)
  @nomal_file = Rails.public_path.join('stop_maintenance.html')
  @maintenance_file = Rails.public_path.join('maintenance.html')
  check_file
  change_mantenance if mode == :start
  change_nomal if mode == :stop
end

def check_file
  if File.exist?(@maintenance_file)
    puts 'メンテナンスモードです'
  elsif File.exist?(@nomal_file)
    puts '通常モードです'
  else
    puts 'メンテナンス用画面が存在しません'
  end
end

def change_mantenance
  return unless File.exist?(@nomal_file)

  puts 'メンテナンスモードに変更します'
  File.rename(@nomal_file, @maintenance_file)
end

def change_nomal
  return unless File.exist?(@maintenance_file)

  puts '通常モードに変更します'
  File.rename(@maintenance_file, @nomal_file)
end

namespace :maintenance do
  task start: :environment do
    maintenance(:start)
  end

  task stop: :environment do
    maintenance(:stop)
  end
end
