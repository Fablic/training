# frozen_string_literal: true
module TasksHelper
  def nl2br(text)
  	h(text).gsub(/\n|\r|\r\n/, "<br>").html_safe
  end
end