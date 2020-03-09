module I18n
  class << self
    alias_method :original_localize, :localize
    def localize(object, options = {})
      object.present? ? original_localize(object, options) : ''
    end
  end
end
