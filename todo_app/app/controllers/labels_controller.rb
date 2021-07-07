# frozen_string_literal: true

class LabelsController < ApplicationController
  before_action :find_label, only: %i[edit update destroy]

  def index
    @labels = Label.includes([:tasks]).page(params[:page])
  end

  def new
    @label = Label.new
  end

  def create
    @label = Label.new(label_params)

    if @label.save
      redirect_to labels_path, flash: { success: I18n.t('labels.flash.success.create') }
    else
      flash.now[:danger] = I18n.t('labels.flash.error.create')
      render :new
    end
  end

  def edit; end

  def update
    if @label.update(label_params)
      redirect_to labels_path, flash: { success: I18n.t('labels.flash.success.update') }
    else
      flash.now[:danger] = I18n.t('labels.flash.error.update')
      render :edit
    end
  end

  def destroy
    if @label.destroy
      redirect_to labels_path, flash: { success: I18n.t('labels.flash.success.destroy') }
    else
      flash.now[:danger] = I18n.t('labels.flash.error.destroy')
      render :index
    end
  end

  private

  def label_params
    params.require(:label).permit(:name)
  end

  def find_label
    @label = Label.find(params[:id])
  end
end
