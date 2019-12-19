require 'sinatra'
require 'sinatra/reloader'

require 'pry'
require 'csv'
require_relative 'app/models/restaurant.rb'

set :bind,'0.0.0.0'  # bind to all interfaces, http://www.sinatrarb.com/configuration.html

get "/" do
  redirect "/restaurants"
end

get "/restaurants" do
  restaurant_csv = CSV.readlines('restaurants.csv', headers: true)
  @restaurant_array = []
  restaurant_csv.each do |restaurant|
    @restaurant_array << Restaurant.new(
      restaurant['id'], restaurant['name'], restaurant['address'], restaurant['description'], restaurant['url'], restaurant['image']
    )
  end
  erb :index
end

get "/restaurants/new" do
  erb :new
end

get "/restaurants/:id" do
  id = params["id"]
  @restaurant_array = []
  restaurant_csv = CSV.readlines('restaurants.csv', headers: true)
  restaurant_csv.each do |restaurant|
    @restaurant_array << Restaurant.new(
      restaurant['id'], restaurant['name'], restaurant['address'], restaurant['description'], restaurant['url'], restaurant['image']
    )
  end

  @restaurant_array.each do |restaurant|
    if restaurant.id == id
      @restaurant_object = restaurant
    end
  end
  erb :show
end

def retrieve_restaurants
  @restaurant_array = []
  restaurant_csv = CSV.readlines('restaurants.csv', headers: true)
  restaurant_csv.each do |restaurant|
    @restaurant_array << Restaurant.new(
      restaurant['id'], restaurant['name'], restaurant['address'], restaurant['description'], restaurant['url'], restaurant['image']
    )
  end
  @restaurant_array
end

post "/restaurants" do
  restaurant_name = params[:name]
  restaurant_address = params[:address]
  restaurant_description = params[:description]
  restaurant_url = params[:url]
  restaurant_image = params[:image]

  last_restaurant_id = retrieve_restaurants.last.id.to_i
  restaurant_id = last_restaurant_id + 1

  if restaurant_name == "" || restaurant_address == "" || restaurant_url == "" || restaurant_image == "" || restaurant_description == ""
    redirect "/restaurants/new"
  else
    CSV.open('restaurants.csv', 'a') do |file|
      file << [restaurant_id, restaurant_name, restaurant_address, restaurant_url, restaurant_image]
    end
  end

  redirect "/restaurants"
end

# post "/articles" do
#   article_description = params[:description]
#   article_title = params[:title]
#   article_url = params[:url]
#
#   if article_description == "" || article_title == "" || article_url == ""
#     redirect "/articles/new"
#   else
#     CSV.open('articles.csv', 'a') do |file|
#       file << [article_description, article_title, article_url]
#     end
#   end
#
#   redirect "/articles"
# end
