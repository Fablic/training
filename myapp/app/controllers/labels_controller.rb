# frozen_string_literal: true

class LabelsController < ApplicationController
  before_action :set_label, only: %i[show edit update destroy]
  before_action :require_admin, only: %i[edit update destroy]

  def index
    @labels = Label.all
  end

  # GET /labels/1
  def show; end

  def new
    @label = Label.new
  end

  def create
    @label = Label.new(label_params)
    if @label.save
      redirect_to labels_path, notice: 'ラベルが作成されました。'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @label.update(label_params)
      redirect_to labels_path, notice: 'ラベルが更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @label.destroy
    redirect_to labels_path, notice: 'ラベルが削除されました。'
  end

  private

  def set_label
    @label = Label.find(params[:id])
  end

  def label_params
    params.require(:label).permit(:name)
  end
end
