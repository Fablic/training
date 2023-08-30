class Admin::LabelsController < ApplicationController
  before_action :check_admin_auth

  def index
    @labels = Label.all
  end

  def new
    @label = Label.new
  end

  def edit
    @label = Label.find(params[:id])
  end

  def create
    @label = Label.new(label_params)
    if @label.save
      flash[:success] = t('label.flashes.success.created')
      redirect_to admin_labels_path
    else
      render :new
    end
  end

  def update
    @label = Label.find(params[:id])
    if @label.update(label_params)
      flash[:notice] = t('label.flashes.success.updated')
      redirect_to admin_labels_path
    else
      render :edit
    end
  end

  def destroy
    @label = Label.find(params[:id])
    puts(@label.tasks)
    @label.tasks.destroy_all
    @label.destroy
    flash[:success] = t('label.flashes.success.deleted')

    redirect_to admin_labels_path
  end

  private

  def label_params
    params.require(:label).permit(:name, :description)
  end
end
