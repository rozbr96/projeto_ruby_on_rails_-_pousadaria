
class AdvancedSearch
  include ActiveModel::Model

  attr_accessor :term, :search_in_name, :search_in_description, :search_in_neighbourhood,
    :search_in_city, :with_pets_allowed, :with_accessibility_for_disabled_people,
    :with_air_conditioning, :with_tv, :with_balcony, :with_vault, :least_number_of_guests,
    :most_number_of_guests, :least_number_of_bathrooms, :most_number_of_bathrooms

  def indifferent? attr
    attr_name = attr.to_s

    raise Exception unless instance_values.key? attr_name

    instance_values[attr_name] == 'indifferent'
  end

  def range_of partial_attribute_name
    lower_limit_attr_name = "least_number_of_#{partial_attribute_name}"
    upper_limit_attr_name = "most_number_of_#{partial_attribute_name}"

    lower_limit = instance_values.dig(lower_limit_attr_name) || ''
    upper_limit = instance_values.dig(upper_limit_attr_name) || ''

    return nil if lower_limit.empty? and upper_limit.empty?


    lower_limit_value = lower_limit.empty? ? -Float::INFINITY : lower_limit.to_i
    upper_limit_value = upper_limit.empty? ?  Float::INFINITY : upper_limit.to_i

    lower_limit_value..upper_limit_value
  end

  def search_in? partial_attribute_name
    attr_name = "search_in_#{partial_attribute_name}"

    raise Exception unless instance_values.key? attr_name

    not instance_values[attr_name].to_i.zero?
  end

  def with? partial_attribute_name
    attr_name = "with_#{partial_attribute_name}"

    raise Exception unless instance_values.key? attr_name

    instance_values[attr_name] == 'yes'
  end
end
