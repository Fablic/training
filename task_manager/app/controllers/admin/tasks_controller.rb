# frozen_string_literal: true

module Admin
  class TasksController < ApplicationController
    def index # rubocop:disable Metrics/AbcSize
      @tasks = Task.search_user_id(params[:user_id])
        .sort_column_direction(params[:sort], params[:direction])
        .search_name(params[:keyword_name]).search_progress(params[:keyword_progress])
        .page(params[:page]).per(10)
      @keyword_name = params[:keyword_name]
      @keyword_progress = params[:keyword_progress]
    end
  end
end
