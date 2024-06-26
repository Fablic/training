# frozen_string_literal: true

class LabelsController < ApplicationController
  before_action :require_admin
  
  def index
    @labels = Label.all
  end

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

  def edit
    @label = Label.find(params[:id])
  end

  def update
    @label = Label.find(params[:id])
    if @label.update(label_params)
      redirect_to labels_path, notice: 'ラベルが更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @label = Label.find(params[:id])
    @label.destroy
    redirect_to labels_path, notice: 'ラベルが削除されました。'
  end

  private

  def label_params
    params.require(:label).permit(:name)
  end
end
