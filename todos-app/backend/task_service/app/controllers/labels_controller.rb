# frozen_string_literal: true

class LabelsController < ApplicationController
  before_action :authorize
  before_action :set_label, only: %i[show update destroy]

  # GET /labels
  def index
    @labels = Label.where(user_id: @user_id)

    render json: @labels
  end

  # GET /labels/1
  def show
    render json: @label
  end

  # POST /labels
  def create
    @label = Label.new(label_params.merge!(user_id: @user_id))

    if @label.save
      render json: @label, status: :created, location: @label
    else
      render json: @label.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /labels/1
  def update
    if @label.update(label_params.merge!(user_id: @user_id))
      render json: @label
    else
      render json: @label.errors, status: :unprocessable_entity
    end
  end

  # DELETE /labels/1
  def destroy
    @label.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_label
    @label = Label.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def label_params
    params.require(:label).permit(:name)
  end
end
