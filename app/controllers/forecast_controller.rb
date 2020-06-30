class ForecastController < ApplicationController

  # GET /forecast
  def index
    @cached_response = false
    address_info = params.dig :address

    if address_info.present?
      forecast_util = ForecastUtil.new

      # query for weather
      @weather_stats, @cached_response = forecast_util.get_sanitized_forecast(address_info)
    end
  end
end
