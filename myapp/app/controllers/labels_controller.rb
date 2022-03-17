class LabelsController < ApplicationController
    before_action :require_sign_in!

    def new
        @label = Label.new
    end

    def create
        @label = Label.new(label_params)
        @label.user_id = @current_user.id
        if @label.save
            redirect_to root_path
        else
            render 'new'
        end
    end

    private
    def label_params
        params.require(:label).permit(:name, :color)
    end
end
