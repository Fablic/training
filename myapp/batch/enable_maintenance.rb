# frozen_string_literal: true

require_relative "../config/application"

File.open(Rails.root.join("tmp", "maintenance.txt"), "w") do |f|
  f.write("Maintenance mode enabled at #{Time.now}")
end
puts "Maintenance mode enabled."
