# frozen_string_literal: true

class LabelsController < ApplicationController
  # ラベル一覧画面
  def index
    @labels = Label.all.page(params[:page])
  end

  # ラベル作成画面
  def new
    @label = Label.new
  end

  # ラベル作成画面
  def create
    @label = Label.new(label_params)

    if @label.save
      redirect_to(labels_path, notice: 'ラベル作成成功')
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  # ラベル詳細画面
  def show
    @label = Label.find(params[:id])
  end

  # ラベル編集画面
  def edit
    @label = Label.find(params[:id])
  end

  # ラベル更新
  def update
    @label = Label.find(params[:id])

    if @label.update(label_params)
      redirect_to(labels_path, notice: 'ラベル更新成功')
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  # ラベル削除
  def destroy
    @label = Label.find(params[:id])
    redirect_to(labels_path, notice: 'ラベル削除成功') if @label.destroy
  end

  private

  # Labelパラメータ
  def label_params
    params.require(:label).permit(:name)
  end
end
