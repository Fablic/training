module Api
  class TaskController < ApplicationController
    def create
      task = Task.new(params.require(:task).permit(Task::EDITABLE_FIELDS))

      # TODO: set proper value when authentication step is done
      task.user_id = 1

      # TODO: check write permission
      task.board_id = params[:board_id]
      task.modified_at = Time.now

      if task.valid?
        task.save
        render json: task, include: Task.apiInclude
      else
        render json: { 'error': task.errors }
      end
    end

    def get
      page = params[:page] || 0
      sort = params[:sort] || 'id'
      board_id = params[:board_id]
      keyword = params[:keyword] || ''
      status_ids = params[:status] ? params[:status].split(',') : nil
      paging = {}

      query = Task.get_list(board_id, sort, status_ids, keyword)

      if page != 0
        query = query.page(page).per(3)
        paging['current'] = query.current_page
        paging['total'] = query.total_pages
      end


      render json: {
        'tasks': query.all.as_json(include: Task.apiInclude),
        'paging': paging
      }
      
    end

    def update
      task = Task.find(params[:id])

      # TODO: check auth
      task.update(params.require(:task).permit(Task::EDITABLE_FIELDS))
      task.modified_at = Time.now

      if task.valid?
        task.save
        render json: task, include: Task.apiInclude
      else
        render json: { 'error': task.errors }
      end
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
