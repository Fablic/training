class ApplicationController < ActionController::Base
  def t(key, options={})
    if key[0] == '.'
      key = controller_name + "_controller." + action_name + key
    end
    super
  end
end
