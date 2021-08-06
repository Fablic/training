class Batch::MaintenanceBatch
  def self.maintenance_start_batch
    if Mode.maintenance_start
      puts 'メンテナンスモードを開始しました。'
    else
      puts 'メンテナンスモードの開始に失敗しました。'
    end
  end

  def self.maintenance_end_batch
    if Mode.maintenance_end
      puts 'メンテナンスモードを終了しました。'
    else
      puts 'メンテナンスモードの終了に失敗しました。'
    end
  end
end
