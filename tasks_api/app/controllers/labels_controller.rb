# frozen_string_literal: true

class LabelsController < ApplicationController
  before_action :sign_in_required

  def index
    @labels = @login_user.labels.all
  end
end
