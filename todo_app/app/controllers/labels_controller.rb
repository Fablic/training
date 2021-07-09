# frozen_string_literal: true

class LabelsController < ApplicationController
  skip_before_action :authenticate_user, only: %i[new create]
  before_action :find_item, only: %i[edit update destroy]

  def new
    @label = Label.new
  end

  def index
    @labels = Label.page(params[:page])
  end

  def create
    @label = Label.new(label_param)
    if @label.save
      redirect_to labels_path, { flash: { success: I18n.t(:'message.registered_label') } }
    else
      flash.now[:error] = I18n.t(:'message.registered_is_failed')
      render :new
    end
  end

  def edit; end

  def update
    if @label.update(label_param)
      redirect_to labels_path, { flash: { success: I18n.t(:'message.edited_label') } }
    else
      flash.now[:error] = I18n.t(:'message.edited_is_faild')
      render :edit
    end
  end

  def destroy
    if @label.destroy
      redirect_to labels_path, { flash: { success: I18n.t(:'message.deleted_label') } }
    else
      flash[:error] = I18n.t(:'message.deleted_is_failed')
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def find_item
    @label = Label.find(params[:id])
  end

  def label_param
    params.require(:label).permit(:name, :color)
  end
end
