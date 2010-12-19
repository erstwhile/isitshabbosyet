require 'rubygems'
require 'httparty'

class Shabbos
  include HTTParty

  attr_accessor :response

  def initialize(zip)
    @response = self.class.get("http://www.hebcal.com/shabbat/?geo=zip;zip=#{zip};m=72;cfg=r")
    @response = @response.parsed_response["rss"]["channel"]["item"]
  end

  def start_time
    start_time = candles[0]["pubDate"]
    Time.parse(start_time).strftime("%H:%M")
  end
  
  def end_time
    end_time = havdalah[0]["pubDate"]
    Time.parse(end_time).strftime("%H:%M")
  end

  def candles
    @response.select { |i| i["category"].eql? "candles" }
  end

  def havdalah
    @response.select { |i| i["category"].eql? "havdalah" }
  end
  
end
