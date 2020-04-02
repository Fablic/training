module TasksHelper
  def render_labels(labels)
    return if labels.nil?
    labels.map{ |f| f.name }.join(',')
  end
end
