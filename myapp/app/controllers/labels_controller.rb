# frozen_string_literal: true

class LabelsController < ApplicationController
  before_action :set_label, only: %i[edit update destroy]

  def index
    @labels = Label.all.page(search_params[:page])
  end

  def new
    @label = Label.new
  end

  def edit; end

  def create
    @label = Label.new(label_params)

    if @label.save
      redirect_to labels_url,
                  flash: { success: I18n.t('messages.create', model_name: I18n.t('activerecord.models.label')) }
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @label.update(label_params)
      redirect_to labels_url,
                  flash: { success: I18n.t('messages.update', model_name: I18n.t('activerecord.models.label')) }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @label.destroy

    redirect_to labels_url,
                flash: { success: I18n.t('messages.destroy', model_name: I18n.t('activerecord.models.label')) }
  end

  private

  def set_label
    raise ActionController::BadRequest if current_user.ordinary?

    @label = Label.find(params[:id])
  end

  def label_params
    params.require(:label).permit(:name)
  end

  def search_params
    params.permit(:page)
  end
end
