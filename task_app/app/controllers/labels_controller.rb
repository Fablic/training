# frozen_string_literal: true

class LabelsController < ApplicationController
  before_action :find_label, only: %i[edit update destroy]

  def index
    @labels = current_user.labels.page(params[:page])
  end

  def new
    @label = current_user.labels.new
  end

  def create
    @label = current_user.labels.new(label_params)

    if @label.save
      redirect_to labels_url, flash: { success: create_flash_message('create', 'success', @label, :name) }
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @label.update(label_params)
      redirect_to labels_url, flash: { success: create_flash_message('update', 'success', @label, :name) }
    else
      render :edit
    end
  end

  def destroy
    if @label.destroy
      flash[:success] = create_flash_message('destroy', 'success', @label, :name)
    else
      flash[:danger] = create_flash_message('destroy', 'failed', @label, :name)
    end

    redirect_to labels_url
  end

  private

  def label_params
    params.require(:label).permit(:name)
  end

  def find_label
    @label = current_user.labels.find(params[:id])
  end
end
