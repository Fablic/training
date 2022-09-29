module Tasks
  class Maintenancer

    def self.start_maintenance(content_id)
      maintenance = Maintenance.find_by(content_id: content_id)
      if maintenance.present? && maintenance.update(maintenance_flg: true)
        # 動作確認のため出力
        puts "#{maintenance.name}のメンテナンス開始"
      else
        # 動作確認のため出力
        puts 'メンテナンス開始に失敗しました'
      end
    end

    def self.end_maintenance(content_id)
      maintenance = Maintenance.find_by(content_id: content_id)
      if maintenance.present? && maintenance.update(maintenance_flg: false)
        # 動作確認のため出力
        puts "#{maintenance.name}のメンテナンス終了"
      else
        # 動作確認のため出力
        puts 'メンテナンス終了に失敗しました'
      end
    end
  end
end
