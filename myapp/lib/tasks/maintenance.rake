# frozen_string_literal: true

desc 'start maintenance mode'
task maintenance_go: :environment do
  File.write('tmp/maintenance.txt', '')
end

desc 'stop maintenance mode'
task maintenance_done: :environment do
  FileUtils.rm_f('tmp/maintenance.txt')
end
