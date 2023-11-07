module GetTimeFromHelper
  def get_time_from value
    value.strftime '%H:%M'
  end
end
