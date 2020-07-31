# frozen_string_literal: true

namespace :add_maintenance do
  desc 'メインテナンス処理の追加 Usage : rake "add_maintenance:exec[test,2020-10-10T10:10:10,2020-10-11T10:10:10]"'
  task :exec, %w[reason str_start_datetime str_end_datetime] => :environment do |_, args|
    start_datetime = parse_datetime(args['str_start_datetime'])
    end_datetime = parse_datetime(args['str_end_datetime'])

    maintenance = Maintenance.new(reason: args['reason'],
                                  start_datetime: start_datetime, end_datetime: end_datetime)
    raise MaintenanceTaskDbError unless maintenance.save

    Rails.logger.info "Maintenance schedule #{maintenance.reason} , id: #{maintenance.id} is created successfully "
  end

  def parse_datetime(str_datetime)
    raise IllegalDateTimeFormatError unless str_datetime.match?(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/)
    Time.strptime(str_datetime, '%Y-%m-%dT%H:%M:%S')
  end
end
