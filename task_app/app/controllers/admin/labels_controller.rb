# frozen_string_literal: true

module Admin
  class LabelsController < ApplicationController
    before_action :forbid_access_except_admin
    before_action :find_label, only: :destroy

    def index
      @labels = Label.page(params[:page])
    end

    def destroy
      if @label.destroy
        flash[:success] = create_flash_message('destroy', 'success', @label, :name)
      else
        flash[:danger] = create_flash_message('destroy', 'failed', @label, :name)
      end

      redirect_to admin_labels_url
    end

    private

    def find_label
      @label = Label.find(params[:id])
    end
  end
end
