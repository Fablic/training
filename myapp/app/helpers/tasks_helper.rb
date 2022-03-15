module TasksHelper
  def task_submit_title
    t("tasks.#{params[:action]}.submit")
  end
end
