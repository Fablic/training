# frozen_string_literal: true

class MaintenancesController < ApplicationController
  skip_before_action :maintenance_mode_switch
  skip_before_action :logged_in_user

  def index
  end
end
