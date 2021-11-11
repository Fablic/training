# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :restrict_user_by_role

  protected

  # redirect if user not logged in or does not have a valid role
  def restrict_user_by_role
    #  unless admin?
    raise ActiveRecord::RecordNotFound unless admin?
  end
end
