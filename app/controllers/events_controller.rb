class EventsController < ApplicationController
  def index
    @events = Event.all

    render("event_templates/index.html.erb")
  end

  def show
    @event = Event.find(params.fetch("id_to_display"))

    render("event_templates/show.html.erb")
  end

  def new_form
    @event = Event.new

    render("event_templates/new_form.html.erb")
  end

  def create_row
    @event = Event.new

    @event.name = params.fetch("name")
    @event.description = params.fetch("description")
    @event.logic = params.fetch("logic")
    @event.frequency = params.fetch("frequency")
    @event.suggested_amount = params.fetch("suggested_amount")

    if @event.valid?
      @event.save

      redirect_back(:fallback_location => "/events", :notice => "Event created successfully.")
    else
      render("event_templates/new_form_with_errors.html.erb")
    end
  end

  def edit_form
    @event = Event.find(params.fetch("prefill_with_id"))

    render("event_templates/edit_form.html.erb")
  end

  def update_row
    @event = Event.find(params.fetch("id_to_modify"))

    @event.name = params.fetch("name")
    @event.description = params.fetch("description")
    @event.logic = params.fetch("logic")
    @event.frequency = params.fetch("frequency")
    @event.suggested_amount = params.fetch("suggested_amount")

    if @event.valid?
      @event.save

      redirect_to("/events/#{@event.id}", :notice => "Event updated successfully.")
    else
      render("event_templates/edit_form_with_errors.html.erb")
    end
  end

  def destroy_row
    @event = Event.find(params.fetch("id_to_remove"))

    @event.destroy

    redirect_to("/events", :notice => "Event deleted successfully.")
  end
  
  def below_freezing
    
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
    
    

  end
end
