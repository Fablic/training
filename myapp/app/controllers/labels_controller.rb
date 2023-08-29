class LabelsController < ApplicationController
  def create
    @label = Label.new(label_params)
    if @label.save
      render json: { success: true, label_id: @label.id }
    else
      render json: { success: false }
    end
  end

  private

  def label_params
    params.require(:label).permit(:name)
  end
end
