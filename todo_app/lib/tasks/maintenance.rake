# frozen_string_literal: true

namespace :maintenance do
  desc 'start maintenance'
  task :start, %i[dir_name reason] => :environment do |task, args|
    template(args[:dir_name], task) do |maintenance_file|
      if File.exist?(maintenance_file)
        puts '既に存在ファイルがします'
      else
        FileUtils.cp(origin_maintenance_file, maintenance_file)
        read_file = File.open(maintenance_file, 'r', &:read)
        reason = args[:reason] || '申し訳ございません'
        read_file.gsub!('REASON', "<p class='mb-0'>#{reason}</p>")
        File.open(maintenance_file, 'r+') do |f|
          f.write(read_file)
        end
      end
    end
  end

  desc 'finish maintenance'
  task :finish, %i[dir_name] => :environment do |task, args|
    template(args[:dir_name], task) do |maintenance_file|
      if File.exist?(maintenance_file)
        FileUtils.rm(maintenance_file)
      else
        puts '既にファイルが削除されています'
      end
    end
  end

  def template(dir_name, task)
    maintenance_batch_start_notify(task)
    if ensure_dir(dir_name)
      maintenance_file = maintenance_file_path(dir_name)
      yield(maintenance_file)
    else
      puts 'ディレクトリが存在しません'
    end
    maintenance_batch_finish_notify(task)
  rescue StandardError => e
    Rails.logger.error(e)
    Rails.logger.error(e.backtrace.join("\n"))
  end

  def maintenance_file_path(dir_name)
    Rails.root.join("app/views/#{dir_name}/maintenance.html.erb")
  end

  def origin_maintenance_file
    Rails.root.join('app/views/errors/maintenance.html.erb')
  end

  def ensure_dir(dir_name)
    Dir.exist?(Rails.root.join("app/views/#{dir_name}"))
  end

  def maintenance_batch_start_notify(task)
    puts "メンテナンスバッチ #{task} を開始します"
  end

  def maintenance_batch_finish_notify(task)
    puts "メンテナンスバッチ #{task} を終了します"
  end
end
