class UserAllTasksQuery
  def initialize(user)
    @tasks = user.tasks.includes([:labels])
  end

  def call(params = {})
    scope = by_text(@tasks, params[:search_text])
    scope = by_status(scope, params[:search_status])
    scope = by_label(scope, params[:search_label])
    order_by(scope, params[:sort_column], params[:sort_type])
  end

  private

  def by_text(scope, text)
    text.present? ? scope.where('title like ? or description like ?', "%#{text}%", "%#{text}%") : scope
  end

  def by_status(scope, status)
    status.present? ? scope.where('status = ?', status) : scope
  end

  def by_label(scope, label)
    label.present? ? scope.joins(:labels).where(labels: { id: label }) : scope
  end

  def order_by(scope, column, type)
    scope.order("#{column} #{type}")
  end
end
