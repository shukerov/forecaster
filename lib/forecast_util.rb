class ForecastUtil
  API_KEY = Rails.application.credentials.open_weather[:api_key]
  CACHE_EXPIRY_PERIOD = 30.minutes

  # HTTP GET - query OpenWeatherAPI for weather data
  #
  # @param address_info [String] address information in the format of 'zipcode,country_code'
  #
  # @return [Hash] the OpenWeather API response
  def get_forecast(address_info)
    url = "https://api.openweathermap.org/data/2.5/weather"
    request_data = {
      method: :get,
      url: url,
      headers: {
        params: {
          zip: address_info,
          units: 'imperial',
          appid: API_KEY,
        }
      }
    }

    # fetch response
    response = RestClient::Request.execute(request_data)

    return JSON.parse(response.body) if response.body.present?
  rescue RestClient::ExceptionWithResponse => err
    code = err.response.code
    return :not_found if code == 404
  end

  # this function extracts the forecast response data we care about
  #
  # @param forecast_response [Hash] the repsonse from OpenWeatherAPI
  #
  # @return [Hash] formatted forecast data
  def forecast_format(forecast_response)
    forecast_data = {
      time_utc: DateTime.strptime(forecast_response["dt"].to_s, "%s"),
      temp: forecast_response.dig("main", "temp").to_f,
      feels_like: forecast_response.dig("main", "feels_like").to_f,
      min: forecast_response.dig("main", "temp_min").to_f,
      max: forecast_response.dig("main", "temp_max").to_f,
      weather: forecast_response.dig("weather", 0, "main"),
      icon: forecast_response.dig("weather", 0, "icon"),
      location_name: forecast_response.dig("name"),
    }

    return forecast_data
  end

  # Fetches forecast info (either from cache or makes a requests),
  # and extracts the specific datapoints 
  #
  # @param address_info [String] address information in the format of 'zipcode,country_code'
  #
  # @return [Hash, Bool] formatted forecast data, and a boolean indicating information
  #   response is coming from the cache
  def get_sanitized_forecast(address_info)
    # lookup value in the cache
    cached = Rails.cache.exist?(address_info)

    forecast_response = Rails.cache.fetch(address_info, expires_in: CACHE_EXPIRY_PERIOD) do
      get_forecast(address_info)
    end
    
    # no weather data was found don't format just return
    return :not_found, cached  if forecast_response == :not_found

    # format forecast data and return
    forecast_formatted = forecast_format(forecast_response)
    return forecast_formatted, cached
  end
end
