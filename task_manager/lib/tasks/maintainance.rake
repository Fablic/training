namespace :maintainance do
  desc 'メンテナンスモードにする'
  task :on do
    Maintainance.on( ENV['reason'] )
  end
  
  desc 'メンテナンスモードを終了する'
  task :off do
    Maintainance.off
  end
end
