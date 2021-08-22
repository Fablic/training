# frozen_string_literal: true

module ApplicationHelper
    def sortable(column, title = nil)
        title ||= column.titleize
        css_class = (column == sort_column) ? "current #{sort_direction}" : nil
        if sort_column == 'created_at' #初期降順
            direction = (column == sort_column && sort_direction == "desc") ? "asc" : "desc"
        else #初期昇順
            direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
        end
        link_to title, {:sort => column, :direction => direction}, {:class => css_class}
    end
end
