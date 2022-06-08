class UserDecorator < Draper::Decorator
  delegate_all

  def admin_flg_show
    if admin_flg == User::ADMIN_USER
      I18n.t('admin.users.admin_flg.true')
    else
      I18n.t('admin.users.admin_flg.false')
    end
  end
end
