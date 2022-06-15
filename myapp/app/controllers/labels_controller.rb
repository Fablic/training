class LabelsController < ApplicationController
  
  def index
    @labels = current_user.labels
  end

  def create
    label = current_user.labels.new(label_params)
    if label.save
      redirect_to labels_path, flash: { success: t('.success') }
    else
      redirect_to labels_path, flash: { danger: t('.failed') }
    end
  end

  def update
    return redirect_to labels_path unless login_user_label?

    label = current_user.labels.find(params[:id])
    if label.update(label_params)
      redirect_to labels_path, flash: { success: t('.success') }
    else
      redirect_to labels_path, flash: { danger: t('.failed') }
    end
  end

  def destroy
    return redirect_to labels_path unless login_user_label?

    label = current_user.labels.find(params[:id])
    label.destroy
    redirect_to labels_path, flash: { success: t('.success') }
  end

  private

  def label_params
    params.require(:label).permit(:name)
  end

  def login_user_label?
    current_user.labels.exists?(id: params[:id])
  end
end
