module GetTextForHelper
  def get_text_for record, attr
    class_name = record.class.name.downcase
    value = record[attr]

    I18n.t "texts.#{class_name}.#{attr}.#{value}"
  end
end
