# タスクの検索用
class SearchForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  ORDER_VALUES = %w[asc desc].freeze
  SORT_DEFAULT = 'created_at'.freeze
  ORDER_DEFAULT = 'asc'.freeze

  attribute :name, :string
  attribute :status, :string
  attribute :sort, :string, default: 'created_at'
  attribute :order, :string, default: 'asc'

  # taskの検索実行
  def exec_search(page)
    if valid?
      tasks = Task.all.order("#{sort_value} #{order_value}")
      tasks.where!('name LIKE ?', "%#{name}%") if name.present?
      tasks.where!(status: status) if status.present?
      tasks.page(page)
    else
      false
    end
  end

  def sort_value
    Task.column_names.include?(sort) ? sort : SORT_DEFAULT
  end

  def order_value
    ORDER_VALUES.include?(order) ? order : ORDER_DEFAULT
  end
end
