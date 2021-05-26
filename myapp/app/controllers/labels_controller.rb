class LabelsController < ApplicationController
  include ErrorValidationExtractor

  def index
    @labels = current_user!.labels.order(:name)
  end

  def new
    @label = Label.new(user: current_user!)
  end

  def edit
    @label = current_user!.labels.find(params.require(:id))
  end

  def create
    label = Label.new(params.require(:label).permit(:name, :color))
    label.user = current_user!
    if label.save
      redirect_to labels_path(I18n.locale), flash: { info: I18n.t('pages.labels.flash.added') }
    else
      redirect_to labels_path(I18n.locale), flash: { error: error_message_from(label) }
    end
  end

  def update
    label = current_user!.labels.find(params.require(:id))
    if label.update(params.require(:label).permit(:name, :color))
      redirect_to labels_path(I18n.locale), flash: { info: I18n.t('pages.labels.flash.edited') }
    else
      redirect_to labels_path(I18n.locale), flash: { error: error_message_from(label) }
    end
  end

  def destroy
    label = current_user!.labels.find(params.require(:id))
    if label.destroy
      redirect_to labels_path(I18n.locale), flash: { info: I18n.t('pages.labels.flash.deleted') }
    else
      redirect_to labels_path(I18n.locale), flash: { error: error_message_from(label) }
    end
  end
end
