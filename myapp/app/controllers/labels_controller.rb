# frozen_string_literal: true

class LabelsController < ApplicationController
  before_action :find_label, only: [:update]

  def update # rubocop:disable Metrics/AbcSize
    if  @find_label.update(request_params)
      redirect_to project_url(id: @find_label.project.id), alert: I18n.t('flash.success_updated', model_name: 'label')
    else
      flash[:alert] = I18n.t('flash.failed_update', model_name: 'label')
      redirect_to project_url(id: @find_label.project.id), notice: @find_label.errors.full_messages
    end
  end

  private

  def find_label
    @find_label ||= Label.find_by!(id: params[:id])
  end

  def request_params
    params.require(:label).permit(:name, :color)
  end
end
