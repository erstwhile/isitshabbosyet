require 'date'
require 'icalendar'
require 'net/https'
require 'json'

before do 
  # Strip the last / from the path
  request.env['PATH_INFO'].gsub!(/\/$/, '')
end

get '/' do
  haml :index    
end

get '/zipcode/:zipcode' do
  content_type :json
  is_it_shabbos_yet(get_shabbos(params[:zipcode]), get_timezone(params[:zipcode]))
  { :h1 => @is_it, :h2 => @why, :zipcode => params[:zipcode] }.to_json
end

get '/style.css' do
  sass :style.css
end

helpers do
  def is_it_shabbos_yet(shabbos_ical_parsed, tzid)
    @shabbos_event = shabbos_ical_parsed
    @shabbos_start = @shabbos_event.first.events.first.dtstart
    @shabbos_end = @shabbos_event.first.events.first.dtend
    @today = DateTime.now.cwday
    @local_time = DateTime.now.to_time.utc + ( 3600 * offset )
#    @today = DateTime.civil(2010, 12, 10, 20,20,1,-5).cwday
#    @local_time = Time.local(2010,"dec",10,20,12,1)
    @location = @shabbos_event.first.events.first.location
    @shabbos_start_hr = @shabbos_start.hour.modulo(12).to_s
    @shabbos_start_min = @shabbos_start.min.to_s.rjust(2, '0')
    @shabbos_end_hr = @shabbos_end.hour.modulo(12).to_s
    @shabbos_end_min = @shabbos_end.min.to_s.rjust(2, '0')

    if @today == 5 && @local_time > @shabbos_start
      @is_it = "Yep."
      @why = "Shabbos started at " + @shabbos_start_hr + ":" + @shabbos_start_min + " pm on Friday and ends at " + @shabbos_end_hr + ":" + @shabbos_end_min + " tomorrow in " + @location
    elsif @today == 5 && @local_time < @shabbos_start
      @is_it = "Not yet."
      @why = "Shabbos starts at " + @shabbos_start_hr + ":" + @shabbos_start_min + " pm in " + @location
    elsif @today == 6 && @local_time < @shabbos_end
      @is_it = "Yep."
      @why = "Shabbos ends at " + @shabbos_end_hr + ":" + @shabbos_end_min + " pm in " + @location
    elsif @today == 6 && @local_time > @shabbos_end
      @is_it = "Nope."
      @why = "Shabbos ended at " + @shabbos_end_hr + ":" + @shabbos_end_min + " pm in " + @location
    else
      @is_it = "Nope."
      @why = "Shabbos starts at " + @shabbos_start_hr + ":" + @shabbos_start_min + " pm this Friday in " + @location
      #@why = ""
    end
  end 

  def get_shabbos(zipcode)
    shabbos_ical_url = URI.parse('http://www.chabad.org/calendar/candlelighting/candlelighting.ics_cdo/z/' + zipcode.to_s + '/weeks/')
    shabbos_ical = Net::HTTP.get(shabbos_ical_url)
    shabbos_ical.slice!(/CHARSET:utf-8\r\n/)
    shabbos_ical = Icalendar.parse(shabbos_ical)
  end
	
  def get_timezone(zipcode)
    zip_lookup_url = URI.parse('http://ws.geonames.org/postalCodeLookupJSON?postalcode=' + zipcode.to_s + '&country=US')
    zip_json = Net::HTTP.get(zip_lookup_url)
    zip_array = JSON::parse(zip_json)['postalcodes'][0].to_hash
    lat_long = {"lat" => zip_array['lat'], "lng" => zip_array['lng'] }
    tz_lookup_url = URI.parse('http://ws.geonames.org/timezoneJSON?lat=' + lat_long['lat'].to_s + '&lng=' + lat_long['lng'].to_s)
    tz_json = Net::HTTP.get(tz_lookup_url)
    tz = JSON::parse(tz_json).to_hash['timezoneId']
  end
end
