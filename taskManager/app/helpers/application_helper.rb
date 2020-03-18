module ApplicationHelper
  def sign_out
    link_to t('action.logout'), sign_out_path, method: :delete , class: 'btn btn-primary' \
      if current_user
  end
end
