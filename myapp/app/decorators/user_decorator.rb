class UserDecorator < Draper::Decorator
  delegate_all

  def admin_flg_show
    if admin_flg == 1
      I18n.t('admin.users.admin_flg.true')
    else
      I18n.t('admin.users.admin_flg.false')
    end
  end
end
