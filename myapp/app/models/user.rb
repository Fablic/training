class User < ApplicationRecord
  has_many :tasks
  has_secure_password

  def searched_tasks(search_form, page)
    if search_form.is_a?(SearchForm) && search_form&.valid?
      searched_tasks = tasks.order("tasks.#{search_form.sort_value} #{search_form.order_value}")
      searched_tasks.where!('name LIKE ?', "%#{search_form.name}%") if search_form.name.present?
      searched_tasks.where!(status: search_form.status) if search_form.status.present?
      searched_tasks.page(page)
    else
      []
    end
  end
end
