namespace :task_maintenance do
  desc 'メンテナンスモード実行/解除'
  task :start do
    unless File.exist?('tmp/maintenance.txt')
      File.new('tmp/maintenance.txt', 'w')
      puts 'メンテナンスモード'
    else
      File.delete('tmp/maintenance.txt')
      puts '通常モード'
    end
  end
end
