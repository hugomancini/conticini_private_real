require 'uri'
require 'net/http'

class PagesController < ApplicationController
	before_action :connectApi
	def show
		@product = ShopifyAPI::Product.find(params[:id])
	end

	def index
		@products = ShopifyAPI::Product.all
	end

  def deliveryValid
    puts "hey yoooo"

    url = URI("https://sandbox.urb-it.com/v2/postalcodes/#{data[:postcode]}")

    http = Net::HTTP.new(url.host, url.port)

    request = Net::HTTP::Get.new(url)
    request["X-API-KEY"] = '92012419-d73a-42f5-a12c-cdcc20740de3'
    request["User-Agent"] = 'PostmanRuntime/7.17.1'
    request["Accept"] = '*/*'
    request["Cache-Control"] = 'no-cache'
    request["Postman-Token"] = '02ed350e-6833-4216-9c7a-dd1a1c27fe13,adf1a8d2-835a-43f9-ad72-0c4dc896fa9c'
    request["Host"] = 'sandbox.urb-it.com'
    request["Accept-Encoding"] = 'gzip, deflate'
    request["Connection"] = 'keep-alive'
    request["cache-control"] = 'no-cache'

    response = http.request(request)
    puts response.read_body
  end

	private

	def connectApi
		shop_url = "https://6620956a37653def370f1cb21fb82e67:f47a2189cb3f4983d295d2867accaec2@hugo-mancini.myshopify.com"
		ShopifyAPI::Base.site = shop_url
		ShopifyAPI::Base.api_version = '2019-07'
	end

end
