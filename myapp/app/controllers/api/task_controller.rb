module Api
  class TaskController < ApplicationController
    def create
      # todo: get user from session
      user = User.get_temporary_user
      throw 403 unless user.get_permission_for(params[:board_id]).can_write?

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

      # todo: get user from session
      user = User.get_temporary_user
      throw 403 unless user.get_permission_for(params[:board_id]).can_read?
      

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
      # todo: get user from session
      user = User.get_temporary_user

      task = Task.find(params[:id])
      throw 403 unless user.get_permission_for(task.board.id).can_write?

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
      # todo: get user from session
      user = User.get_temporary_user

      task = Task.find(params[:id])

      throw 403 unless user.get_permission_for(task.board.id).can_write?

      # TODO: check auth
      task.delete

      render json: {
        'id': params[:id]
      }
    end
  end
end
