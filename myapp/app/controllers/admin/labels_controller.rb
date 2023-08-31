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
      redirect_to admin_labels_path, flash: { success:  t('label.flashes.success.created')}
    else
      render :new
    end
  end

  def update
    @label = Label.find(params[:id])
    if @label.update(label_params)
      redirect_to admin_labels_path, flash: { notice:  t('label.flashes.success.updated')}
    else
      render :edit
    end
  end

  def destroy
    @label = Label.find(params[:id])
    @label.tasks.destroy_all
    @label.destroy
    redirect_to admin_labels_path, flash: { success:  t('label.flashes.success.deleted')}
  end

  private

  def label_params
    params.require(:label).permit(:name, :description)
  end
end
