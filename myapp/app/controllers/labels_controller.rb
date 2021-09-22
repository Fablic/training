class LabelsController < ApplicationController
  before_action :_login_check
  before_action :_set_label, only: %i[update destroy]

  def index
    @labels = current_user.labels
  end

  def create
    @label = current_user.labels.new(label_params)

    if @label.save
      redirect_to labels_path, flash: { success: I18n.t('flash.new_label_success') }
    else
      flash[:danger] = I18n.t('flash.new_label_danger')
      flash[:validation_error] = @label.errors.full_messages
      redirect_to labels_path
    end
  end

  def update
    if @label.update(label_params)
      redirect_to labels_path, flash: { success: I18n.t('flash.updated_label_success') }
    else
      flash[:danger] = I18n.t('flash.updated_label_danger')
      flash[:validation_error] = @label.errors.full_messages
      redirect_to labels_path
    end
  end

  def destroy
    @label.destroy

    redirect_to labels_path, flash: { success: I18n.t('flash.label_destroy') }
  end

  def label_params
    params.require(:label).permit(:name)
  end

  private

  def _set_label
    @label = current_user.labels.find(params[:id])
  end
end
