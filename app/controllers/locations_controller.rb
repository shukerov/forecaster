class LocationsController < ApplicationController

  # GET /locations/index.json
  def index
    address = params.dig :address_search
    locations = []

    # get locations
    if address.present? 
      locations = Geocoder.search(address)

      # filter locations that have a zipcode only
      locations = locations.map { |location|
        { 
          address_name: location.address,
          address_info: "#{location.postal_code},#{location.country_code}",
        } unless location.postal_code.nil?
      }.compact
    end

    respond_to do |format|
      format.json do
        render json: locations.to_json
      end
    end
  end
end
