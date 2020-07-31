# frozen_string_literal: true

namespace :delete_maintenance do
  desc 'メインテナンス処理の削除 Usage : rake "delete_maintenance:exec[1]"'
  task :exec, ['id'] => :environment do |_, args|
    raise MaintenanceTaskDbError unless Maintenance.destroy(args['id'].to_i)

    Rails.logger.info "Maintenance id #{args['id']} is deleted successfully "
  end
end
