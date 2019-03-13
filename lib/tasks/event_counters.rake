task :freezing_counter => :environment do
require 'open-uri'
CustomizedPreference.where(:event_id => "#{Event.first.id}").each do |preference|
      
  @street_address = User.find_by(id: preference.user_id).location
    sanitized_street_address = URI.encode(@street_address)

url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{sanitized_street_address.to_s}&key=AIzaSyBr-0XDfztIIUGyPRfa1D5KfPvURvAk2e4"
parsed_data = JSON.parse(open(url).read)
latitude = parsed_data.dig("results", 0, "geometry", "location", "lat")
longitude = parsed_data.dig("results", 0, "geometry", "location", "lng")

url_dos = "https://api.darksky.net/forecast/8707954d64e5b10beab32c74ed9d5927/#{latitude.to_s},#{longitude.to_s}"
parsed_data_dos = JSON.parse(open(url_dos).read)

    @current_temperature = parsed_data_dos.dig("currently","temperature").to_i
    
  #   @daily_low = parsed_data_dos.dig("daily","data[0]","temperatureLow").to_i
  # ap(@daily_low)
  
  if @current_temperature < 300
      @total= Goal.find_by(id: preference.goal_id).current_amount.to_i
      @total= @total + 1
      @total= @total.to_s
      @a=Goal.find_by(id: preference.goal_id)
      @a.current_amount= @total
      @a.save
      
    else
  end
  end
  
  
end