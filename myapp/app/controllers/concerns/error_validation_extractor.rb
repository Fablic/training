module ErrorValidationExtractor
  private

  def error_message_from(model)
    prefix = ->(xs) { xs.map { |x| "- #{x}" } }
    model.errors.messages.values.flat_map(&prefix).join("\n").presence or raise 'This should be called only when validation fails'
  end
end
