# frozen_string_literal: true

module Admin
  class LabelsController < ApplicationController # rubocop:disable Style/Documentation
    def index
      @labels = Label.all.eager_load(:tasks).order(created_at: :asc)
      @total_labels_count = @labels.count
    end

    def destroy
      @label = Label.find(params[:id])
      if @label.destroy
        flash[:notice] = I18n.t('admin.labels.delete_success')
      else
        flash[:alert] = I18n.t('admin.labels.delete_failure')
      end
      redirect_to admin_labels_path
    end
  end
end
