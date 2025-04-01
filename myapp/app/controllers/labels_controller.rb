class LabelsController < ApplicationController
  before_action :set_label, only: [:show, :edit, :update, :destroy]
  before_action :require_login
  before_action :authorize_user, only: [:show, :edit, :update, :destroy]

  def index
    @labels = current_user.labels
  end

  def show
  end

  def new
    @label = Label.new
  end

  def create
    @label = current_user.labels.new(label_params)
    if @label.save
      flash[:notice] = I18n.t 'msg_create_label_success'
      redirect_to @label
    else
      flash.now[:alert] = I18n.t 'msg_create_label_failure'
      render :new, status: 422
    end
  end

  def edit
  end

  def update
    if @label.update(label_params)
      flash[:notice] = I18n.t 'msg_update_label_success'
      redirect_to @label
    else
      flash.now[:alert] = I18n.t 'msg_update_label_failure'
      render :edit, status: 422
    end
  end

  def destroy
    if @label.destroy
      flash[:notice] = I18n.t 'msg_delete_label_success'
      redirect_to labels_url
    else
      flash[:alert] = I18n.t 'msg_delete_label_failure'
      redirect_to @label
    end
  end

  private

  def set_label
    @label = Label.find(params[:id])
  end

  def label_params
    params.require(:label).permit(:name)
  end

  def authorize_user
    raise ActionController::RoutingError, "404" unless @label.user == current_user
  end
end
