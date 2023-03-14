class ControllersController < ApplicationController
  before_action :set_controller, only: %i[ show edit update destroy ]

  # GET /controllers or /controllers.json
  def index
    @controllers = Controller.all
  end

  # GET /controllers/1 or /controllers/1.json
  def show
  end

  # GET /controllers/new
  def new
    @controller = Controller.new
  end

  # GET /controllers/1/edit
  def edit
  end

  # POST /controllers or /controllers.json
  def create
    @controller = Controller.new(controller_params)

    respond_to do |format|
      if @controller.save
        format.html { redirect_to controller_url(@controller), notice: "Controller was successfully created." }
        format.json { render :show, status: :created, location: @controller }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @controller.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /controllers/1 or /controllers/1.json
  def update
    respond_to do |format|
      if @controller.update(controller_params)
        format.html { redirect_to controller_url(@controller), notice: "Controller was successfully updated." }
        format.json { render :show, status: :ok, location: @controller }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @controller.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /controllers/1 or /controllers/1.json
  def destroy
    @controller.destroy

    respond_to do |format|
      format.html { redirect_to controllers_url, notice: "Controller was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_controller
      @controller = Controller.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def controller_params
      params.require(:controller).permit(:Sessions, :new)
    end
end
