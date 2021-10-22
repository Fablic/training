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
  attribute :label_ids

  def sort_value
    Task.column_names.include?(sort) ? sort : SORT_DEFAULT
  end

  def order_value
    ORDER_VALUES.include?(order) ? order : ORDER_DEFAULT
  end
end
