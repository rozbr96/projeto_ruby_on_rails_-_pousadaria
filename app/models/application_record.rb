class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.human_enum_name_for enum_name, value
    I18n.t "activerecord.attributes.#{model_name.i18n_key}.#{enum_name.to_s}.#{value}"
  end
end
