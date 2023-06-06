class LabelsController < ApplicationController
  before_action :require_login
  before_action :add_label_id, only: [:show]
  before_action :ensure_correct_user, only: %i[edit update destroy]

  def index
    @labels = Label.includes(:tasks)
    .includes(:user)
    .order(created_at: 'DESC')
    .page(params[:page]).per(5)
  end

  def show
    @tasks = @label.tasks
  end

  def new
    @label = Label.new
  end

  def edit; end

  def create
    @label = @current_user.labels.new(label_params)
    if @label.save
      redirect_to labels_path, success: t('messages.create', model_name: t('activerecord.models.label'))
    else
      render :new
    end
  end

  def update
    if @label.update(label_params)
      redirect_to labels_path, success: t('messages.update', model_name: t('activerecord.models.label'))
    else
      render :edit
    end
  end

  def destroy
    if @label.destroy
      redirect_to labels_path, success: t('messages.delete', model_name: t('activerecord.models.label'))
    else
      render :index
    end
  end

  private

  def add_label_id
    @label = Label.find(params[:id])
  end

  def ensure_correct_user
    @label = @current_user.labels.find(params[:id])
    return if @label.user == @current_user

    redirect_to labels_path, danger: t('error.messages.no_authority')
  end

  def label_params
    params.require(:label).permit(:name, :description, :status, :deadline_at)
  end
end
