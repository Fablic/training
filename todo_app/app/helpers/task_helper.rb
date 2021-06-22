# frozen_string_literal: true

module TaskHelper
  def default_select_status
    @status.nil? ? nil : @status
  end
end
