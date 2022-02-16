module Api
  class TaskController < ApplicationController
    
    def post
      task = Task.new
      
      #todo: set proper value when authentication step is done
      task.user_id = 1
      #todo: check write permission
      task.board_id = params[:board_id]
      
      for column in Task::EDITABLE_FIELDS
        task[column] = params[column]
      end

      task.modified_at = Time.now;
      task.save

      render :json => task, include: Task.apiInclude

    end

    def get
      @tasks = Task.all
      
      render :json => @tasks, include: Task.apiInclude

    end

    def patch
      task = Task.find(params[:task_id])

      #todo: check auth
      editableColumns = [:title, :status_id, :due_date, :contents, :priority_id]
      
      for column in Task::EDITABLE_FIELDS
        if(params.has_key?(column))
          task[column] = params[column]
        end
      end
            
      #todo: check status change was valid or not
      
      task.modified_at = Time.now;
      task.save

      render :json => task, include: Task.apiInclude
    end

    def delete
      task = Task.find(params[:task_id])

      #todo: check auth
      task.delete

      render :json => {
        'id': params[:task_id]
      }
    end

  end
end