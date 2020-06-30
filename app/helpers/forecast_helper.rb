module ForecastHelper
  # appends degree symbol to the end of a string
  #
  # @param degrees [Number] the number to append a degree symbol to_s
  # @return [String]
  def display_degrees(degrees)
    raise TypeError unless degrees.is_a? Numeric
    (degrees.to_s + "&deg;").html_safe
  end
end
