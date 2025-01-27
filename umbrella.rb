# Write your soltuion here!
require "http"
require "dotenv/load"
require "json"

line_width = 50

puts "=" * line_width
puts "Will you need an umbrella today?".center(line_width)
puts "=" * line_width

pp "Hi! Where are you located?"

user_loc = gets.chomp

#user_loc = "Chicago Booth Harper Center" 

# pp user_loc 

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_loc}&key=#{ENV.fetch("gmaps_key")}"

# pp gmaps_url

raw_location = HTTP.get(gmaps_url)

parsed_location = JSON.parse(raw_location)

# pp parsed_location

lat = parsed_location.fetch("results").at(0).fetch("geometry").fetch("location").fetch("lat") 
lng = parsed_location.fetch("results").at(0).fetch("geometry").fetch("location").fetch("lng") 

pirate_weather_api_key = ENV.fetch("pirate_weather_key") 

pirate_weather_url = "https://api.pirateweather.net/forecast/" + pirate_weather_api_key + "/#{lat},#{lng}"

# pp pirate_weather_url

raw_weather = HTTP.get(pirate_weather_url)

parsed_weather = JSON.parse(raw_weather)

temperature = parsed_weather.fetch("currently").fetch("temperature")

pp "The current temperature at #{user_loc} is #{temperature} F"

hourly_data = parsed_weather.fetch("hourly").fetch("data").at(0).fetch("time")

condition = parsed_weather.fetch("hourly").fetch("data").at(0).fetch("summary")

current_hour = Time.at(hourly_data).strftime("%a %e, %R %p")

pp "The weather will be #{condition} in the next hour"

next_twelve_hours = parsed_weather.fetch("hourly").fetch("data")

precip_threshold = 0.1 

umbrella_check = 0

count = 1

next_twelve_hours[0..11].each do |hourly_data|
  hour_precip = hourly_data.fetch("precipProbability")
  if hour_precip.to_f >= precip_threshold
    pp "There is #{hour_precip} probability that it will rain #{count} hours from now"
    umbrella_check = umbrella_check + 1
    count = count + 1
  end
  # pp umbrella_check

end

if umbrella_check < 1
  pp "You don't need to bring your umbrella"
else pp "You should bring your umbrella"
end
