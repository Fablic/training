module Tasks
  class Maintenancer
    def self.start_index_maintenance
      start_maintenance(TASK_INDEX, I18n.t('tasks.index.page_title'))
    end

    def self.end_index_maintenance
      end_maintenance(TASK_INDEX, I18n.t('tasks.index.page_title'))
    end

    def self.start_show_maintenance
      start_maintenance(TASK_SHOW, I18n.t('tasks.show.page_title'))
    end

    def self.end_show_maintenance
      end_maintenance(TASK_SHOW, I18n.t('tasks.show.page_title'))
    end

    def self.start_new_maintenance
      start_maintenance(TASK_NEW, I18n.t('tasks.new.page_title'))
    end

    def self.end_new_maintenance
      end_maintenance(TASK_NEW, I18n.t('tasks.new.page_title'))
    end

    def self.start_edit_maintenance
      start_maintenance(TASK_EDIT, I18n.t('tasks.edit.page_title'))
    end

    def self.end_edit_maintenance
      end_maintenance(TASK_EDIT, I18n.t('tasks.edit.page_title'))
    end

    private

    def self.start_maintenance(content_id, type)
      maintenance = Maintenance.find_by(content_id: content_id)
      if maintenance.present? && maintenance.update(maintenance_flg: true)
        # 動作確認のため出力
        puts "#{type}のメンテナンス開始"
      else
        # 動作確認のため出力
        puts "#{type}に失敗しました"
      end
    end

    def self.end_maintenance(content_id, type)
      maintenance = Maintenance.find_by(content_id: content_id)
      if maintenance.present? && maintenance.update(maintenance_flg: false)
        # 動作確認のため出力
        puts "#{type}のメンテナンス終了"
      else
        # 動作確認のため出力
        puts "#{type}に失敗しました"
      end
    end
  end
end
