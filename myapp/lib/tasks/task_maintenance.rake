namespace :task_maintenance do
  desc 'メンテナンスモード実行/解除'
  task :start do
    unless File.exist?("lib/maintenance/maintenance.txt")
      File.new("lib/maintenance/maintenance.txt", "w")
      puts 'メンテナンスモード'
    else
      File.delete("lib/maintenance/maintenance.txt")
      puts '通常モード'
    end
  end
end
