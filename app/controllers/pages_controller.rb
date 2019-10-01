require 'uri'
require 'net/http'
require 'json'

class PagesController < ApplicationController
	before_action :connectApi
	def show
		@product = ShopifyAPI::Product.find(params[:id])
	end

	def index
		@products = ShopifyAPI::Product.all
	end

  def deliveryValid
    #getting info on wether the area is inside delivery area
    uri = URI.parse("https://sandbox.urb-it.com/v2/postalcodes/#{params[:postcode]}")
    request = Net::HTTP::Get.new(uri)
    request["X-Api-Key"] = "92012419-d73a-42f5-a12c-cdcc20740de3"
    req_options = {
      use_ssl: uri.scheme == "https",
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
     response.code
     answer = response.body
     jsonAnswer = JSON.parse(answer)
     @answer = jsonAnswer["inside_delivery_area"]
     puts @answer
     # if it is, then we get the hash of all delivery slots available
      if @answer != "no"
       puts "ALL GOOD INSIDE THE BOUCLE BB"
       uri = URI.parse("https://sandbox.urb-it.com/v2/slots")
       request = Net::HTTP::Get.new(uri)
       request["X-Api-Key"] = "92012419-d73a-42f5-a12c-cdcc20740de3"

       req_options = {
         use_ssl: uri.scheme == "https",
       }

       response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
         http.request(request)
       end
       response.code
       deliverySlots = response.body
       jsonDeliverySlots = JSON.parse(deliverySlots)
       render json: {slots: jsonDeliverySlots}
      else
    # if not, then we put an error message
       puts "Does #{params[:postcode]} can be delivered ? Answer is : #{@answer}"
       render json: {answer: @answer}
      end
  end

	private

	def connectApi
		shop_url = "https://6620956a37653def370f1cb21fb82e67:f47a2189cb3f4983d295d2867accaec2@hugo-mancini.myshopify.com"
		ShopifyAPI::Base.site = shop_url
		ShopifyAPI::Base.api_version = '2019-07'
	end

end
