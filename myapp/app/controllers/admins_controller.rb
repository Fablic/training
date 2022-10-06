# frozen_string_literal: true

class AdminsController < ApplicationController
  before_action :check_admin_user

  private

  def check_admin_user
    return if current_user.admin?

    redirect_to root_url, flash: { danger: I18n.t('admin_page.index.no_admin') }
  end
end
