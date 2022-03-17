namespace :maintenance do
    desc 'start maintenance'
    task :start do
        file = File.new("public/maintenance","w")
        file.close
    end

    desc 'stop maintenance'
    task :stop do
        File.delete("public/maintenance") if File.exist?("public/maintenance")
    end
end
