# frozen_string_literal: true

# some comments here for label controller
class LabelsController < ApplicationController
  before_action :set_label, only: [:show, :edit, :update, :destroy]

  def index
    @labels = Label.get_own_labels(@current_user.id)
                   .page(params[:page])
  end

  def show
  end

  def new
    @label = Label.new
  end

  def edit
  end

  def create
    @label = Label.new(label_params)
    if @label.save
      redirect_to labels_path, flash: { success: t('flash_msgs.label.create_ok') }
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if label_name_duplicate?(label_params)
      redirect_to label_path(@label), flash: { success: t('flash_msgs.label.duplicate_name') }
    end
    if @label.update(label_params)
      redirect_to label_path(@label), flash: { success: t('flash_msgs.label.update_ok') }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    return unless @label.destroy

    redirect_to labels_path, flash: { success: t('flash_msgs.label.delete_ok') }
  end

  private

  def set_label
    @label = Label.find(params[:id])
  end

  def label_params
    params.require(:label).permit(:name).merge(user_id: @current_user.id)
  end

  def label_name_duplicate?(params)
    labelname = params[:name]
    if labelname == @label.name || !Label.find_by(name: labelname)
      return false
    end

    true
  end
end
