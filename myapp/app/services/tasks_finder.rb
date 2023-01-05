class TasksFinder
  attr_reader :params, :tasks

  def initialize(params:, tasks:)
    @params = params
    @tasks = tasks
  end

  def process
    collection = @tasks
    filter_tasks(collection)
  end

  private

  def filter_tasks(collection)
    collection = by_title(collection)
    collection = by_status(collection)
    collection
  end

  def by_title(collection)
    return collection if @params[:search_title].blank?
    search_title = @params[:search_title]

    collection = collection.by_title(search_title)
    collection
  end

  def by_status(collection)
    return collection if @params[:status].blank?
    status = @params[:status]

    collection = collection.where(status: status)
    collection
  end
end
