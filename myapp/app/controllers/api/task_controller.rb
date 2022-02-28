module Api
  class TaskController < ApplicationController
    def create
      task = Task.new(params.require(:task).permit(Task::EDITABLE_FIELDS))

      # TODO: set proper value when authentication step is done
      task.user_id = 1

      # TODO: check write permission
      task.board_id = params[:board_id]
      task.modified_at = Time.now
      task.save

      render json: task, include: Task.apiInclude
    end

    def get
      @tasks = Task.where(board_id: params[:board_id]).all

      render json: @tasks, include: Task.apiInclude
    end

    def update
      task = Task.find(params[:id])

      # TODO: check auth
      task.update(params.require(:task).permit(Task::EDITABLE_FIELDS))

      # TODO: check status change was valid or not

      task.modified_at = Time.now
      task.save

      render json: task, include: Task.apiInclude
    end

    def destroy
      task = Task.find(params[:id])

      # TODO: check auth
      task.delete

      render json: {
        'id': params[:id]
      }
    end
  end
end
