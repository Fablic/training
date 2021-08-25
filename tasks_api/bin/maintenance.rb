# frozen_string_literal: true

case ARGV[0]
when 'show'
  Maintenance.all.each { |m| p m }
when 'set'
  p Maintenance.new(name: ARGV[1]).save
when 'unset'
  p Maintenance.all.map(&:destroy)
end
