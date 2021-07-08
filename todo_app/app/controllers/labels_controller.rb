# frozen_string_literal: true

class LabelsController < ApplicationController
  skip_before_action :authenticate_user, only: %i[new create]

  def new
    @label = Label.new
  end

  def index
    @labels = Label.page(params[:page])
  end

  def create
    @label = Label.new(label_param)
    if @label.save
      redirect_to root_path, { flash: { success: I18n.t(:'message.registered_user') } }
    else
      flash.now[:error] = I18n.t(:'message.registered_is_failed')
      render :new
    end
  end

  private

  def label_param
    params.require(:label).permit(:name, :color)
  end
end
