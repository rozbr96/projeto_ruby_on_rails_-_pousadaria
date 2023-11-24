
module GetBooleanTextForHelper
  def get_boolean_text_for value
    I18n.t "boolean.#{value.to_s}"
  end
end
