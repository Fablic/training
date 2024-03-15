class LabelsController < ApplicationController
  before_action :set_label, only: [:show, :edit, :update, :destroy]

  # GET /labels or /labels.json
  def index
    @labels = Label.get_own_labels(@current_user.id)
  end

  # GET /labels/1 or /labels/1.json
  def show
  end

  # GET /labels/new
  def new
    @label = Label.new
  end

  # GET /labels/1/edit
  def edit
  end

  # POST /labels or /labels.json
  def create
    @label = Label.new(label_params)

    respond_to do |format|
      if @label.save
        flash[:success] = "Label was successfully created."
        format.html { redirect_to label_url(@label) }
        format.json { render :show, status: :created, location: @label }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @label.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /labels/1 or /labels/1.json
  def update
    respond_to do |format|
      if @label.update(label_params)
        flash[:success] = "Label was successfully updated."
        format.html { redirect_to label_url(@label) }
        format.json { render :show, status: :ok, location: @label }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @label.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /labels/1 or /labels/1.json
  def destroy
    @label.destroy
    respond_to do |format|
      flash[:success] ="Label was successfully destroyed."
      format.html { redirect_to labels_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_label
      @label = Label.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def label_params
      params.fetch(:label).permit(:name).merge(user_id: @current_user.id)
    end

    def label_name_duplicate?(params)
      labelname = params[:name]
      if labelname == @label.name || !Label.find_by(name: labelname)
        return false
      end
      true
    end
end
