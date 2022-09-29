module Tasks
    class Maintenancer

      def self.start(function_id)
        maintenance = Maintenance.find_by(function_id: function_id)
        if maintenance.present? && maintenance.update(maintenance_flag: true)
          # バッチコマンドの動作確認用
          puts "success:メンテナンス開始(function_id:#{function_id})"
        else
          # バッチコマンドの動作確認用
          puts "failed:メンテナンス開始失敗(function_id:#{function_id}"
        end
      end

      def self.end(function_id)
        maintenance = Maintenance.find_by(function_id: function_id)
        if maintenance.present? && maintenance.update(maintenance_flag: false)
          # バッチコマンドの動作確認用
          puts "success:メンテナンス終了(function_id:#{function_id})"
        else
          # バッチコマンドの動作確認用
          puts "failed:メンテナンス終了失敗(function_id:#{function_id}"
        end
      end
    end
  end
