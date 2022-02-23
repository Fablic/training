module Api
  class TaskController < ApplicationController
    
    def create
      task = Task.new(params.require(:task).permit(Task::EDITABLE_FIELDS))
      
      #todo: set proper value when authentication step is done
      task.user_id = 1

      #todo: check write permission
      task.board_id = params[:board_id]
      task.modified_at = Time.now;
      task.save

      render :json => task, include: Task.apiInclude

    end

    def get
      @tasks = Task.where(board_id: params[:board_id]).all()
      
      render :json => @tasks, include: Task.apiInclude

    end

    def update
      task = Task.find(params[:id])

      #todo: check auth
      task.update(params.require(:task).permit(Task::EDITABLE_FIELDS))
            
      #todo: check status change was valid or not
      
      task.modified_at = Time.now;
      task.save

      render :json => task, include: Task.apiInclude
    end

    def destroy
      task = Task.find(params[:id])

      #todo: check auth
      task.delete

      render :json => {
        'id': params[:id]
      }
    end

  end
end
