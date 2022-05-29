module TasksHelper
  def task_submit_title
    I18n.t("tasks.#{params[:action]}.submit")
  end
end
