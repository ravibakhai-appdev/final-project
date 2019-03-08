task :freezing_counter do
  
  
  Cusomized_preference.where(:event_id => "freezing").each do |preference|
      
   @street_address = params.fetch("user_location")
    sanitized_street_address = URI.encode(@street_address)

url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{sanitized_street_address.to_s}&key=AIzaSyBr-0XDfztIIUGyPRfa1D5KfPvURvAk2e4"
parsed_data = JSON.parse(open(url).read)
latitude = parsed_data.dig("results", 0, "geometry", "location", "lat")
longitude = parsed_data.dig("results", 0, "geometry", "location", "lng")

url_dos = "https://api.darksky.net/forecast/8707954d64e5b10beab32c74ed9d5927/#{latitude.to_s},#{longitude.to_s}"
parsed_data_dos = JSON.parse(open(url_dos).read)

    @current_temperature = parsed_data_dos.dig("currently","temperature")

    @daily_low = parsed_data_dos.dig("daily","temperatureLow")
    
  if @daily_low.to_f < 32
      @total=Goal.find_by(:id => "#{preference.goal_id}").current_amount
      @total=(@total+5)
    else
  end
  #SUPER ROUGH LOGIC, NEED TO REFINE FREEZING HASH, CONSIDER CREATING A PERMANENT FREEZING EVENT WITH UNIQUE ID?
  end
end