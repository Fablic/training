module TaskHelper
  def options_for_select_of_statuses
    Task.statuses.map{|i| [I18n.t(i[0], scope: [:activerecord, :attributes, :task, :statuses]), i[1]]}
  end
end