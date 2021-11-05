# frozen_string_literal: true

class LabelsController < ApplicationController
  # labels GET /labels(.:format) labels#index
  def index
    @labels = current_user.labels
  end

  # POST /labels(.:format) labels#create
  def create
    @label = current_user.labels.new(label_params)

    if @label.save
      redirect_to labels_path, flash: { success: 'label successfuly created' }
    else
      flash[:danger] = I18n.t('flash.new_label_danger')
      flash[:validation_error] = @label.errors.full_messages
      redirect_to labels_path
    end
  end

  # PATCH  /labels/:id(.:format) labels#update
  def update
    @label = current_user.labels.find(params[:id])

    if @label.update(label_params)
      redirect_to labels_path, flash: { success: 'label successfuly updated' }
    else
      flash[:danger] = 'label update failed'
      redirect_to labels_path
    end
  end

  # DELETE /labels/:id(.:format) labels#destroy
  def destroy
    @label = current_user.labels.find(params[:id])
    @label.destroy

    redirect_to labels_path, flash: { success: 'label successfuly deleted' }
  end

  private

  def label_params
    params.fetch(:label, {}).permit(:name)
  end
end
