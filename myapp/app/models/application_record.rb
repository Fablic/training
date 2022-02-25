class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def enum_i18n(enum_name)
    return nil if self.send(enum_name).nil?
    I18n.t!("enums.#{self.model_name.i18n_key}.#{enum_name}.#{self.send(enum_name)}")
  end

  def self.enums_i18n(enum_name)
    self.send(enum_name.to_s.pluralize).map do |key, value|
      [I18n.t!("enums.#{self.model_name.i18n_key}.#{enum_name}.#{key}"), value]
    end.to_h
  end
end
