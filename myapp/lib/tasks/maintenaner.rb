module Tasks
  class Maintenaner
    def self.start_maintenance
      switch_maintenance(true, 'メンテナンス開始')
    end

    def self.end_maintenance
      switch_maintenance(false, 'メンテナンス終了')
    end

    private

    def self.switch_maintenance(maintenance_flg, type)
      maintenance = Maintenance.find_by(service_id: TASK)
      if maintenance.present? && maintenance.update(maintenance_flg: maintenance_flg)
        # 動作確認のため出力
        puts "#{type}"
      else
        # 動作確認のため出力
        puts "#{type}に失敗しました"
      end
    end
  end
end
