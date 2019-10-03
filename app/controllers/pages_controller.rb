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


  def getCartJson
      hash = {"items" => [
            {'sku' => 'noke-12345B',
            'name' => 'Noke Sneakers',
             'vat' => 2000,
             'price' => 5999,
             'quantity' => 2
               }]}
      @json = hash.to_json
      return @json
  end

  def setDateTimeRecipient(checkoutId)
    @json3 = {
        "delivery_time" => "2018-01-28T19:43:00Z",
        "message" => "Door code: 1234",
        "recipient" => {
          "first_name" => "Test",
          "last_name" => "Testsson",
          "address_1" => "Example street 52",
          "address_2" => "",
          "city" => "Paris",
          "postcode" => "75000",
          "phone_number" => "+331612345678",
          "email" => "test@grr.la"
        }
      }
    uri = URI.parse("https://sandbox.urb-it.com/v3/checkouts/#{checkoutId}/delivery")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Authorization"] = "Bearer <JWT Authorization Header>"
    request["X-Api-Key"] = "92012419-d73a-42f5-a12c-cdcc20740de3"
    request.body = @json3
    puts request.body
    req_options = {
      use_ssl: uri.scheme == "https",
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    response.code
    answer = response.body
    jsonAnswer = JSON.parse(answer)
    puts "THIS IS THE API ANSWER : "
    puts jsonAnswer
  end

  def initiateCheckOut(cartId)
    @json2 = { "cart_reference" => @cartId }
    uri = URI.parse("https://sandbox.urb-it.com/v3/checkouts")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Authorization"] = "Bearer <JWT Authorization Header>"
    request["X-Api-Key"] = "92012419-d73a-42f5-a12c-cdcc20740de3"
    request.body = @json2
    puts request.body
    req_options = {
      use_ssl: uri.scheme == "https",
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    response.code
    answer = response.body
    jsonAnswer = JSON.parse(answer)
    puts "THIS IS THE API ANSWER : "
    puts jsonAnswer
    @checkoutId = jsonAnswer["id"]
    setDateTimeRecipient(@checkoutId)
  end

  def initiateCart
    getCartJson
    puts "INITIAITIEI CAAARRTT"
    uri = URI.parse("https://sandbox.urb-it.com/v2/carts")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Authorization"] = "Bearer <JWT Authorization Header>"
    request["X-Api-Key"] = "92012419-d73a-42f5-a12c-cdcc20740de3"
    request.body = @json
    puts request.body
    req_options = {
      use_ssl: uri.scheme == "https",
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    response.code
    answer = response.body
    jsonAnswer = JSON.parse(answer)
    puts "THIS IS THE API ANSWER : "
    puts jsonAnswer
    @cartId = jsonAnswer["id"].to_s
    initiateCheckOut(@cartId)
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
       deliveryArray = jsonDeliverySlots["items"]
       @deliveryHours = []
       deliveryArray.each do |item|
          @deliveryHour = item["delivery_time"]
          @deliveryHourFinal = Date.parse(@deliveryHour).strftime("%a %b %e %Y %H:%M")
          @deliveryHours << @deliveryHourFinal
       end
       puts @deliveryHours
       puts @deliveryHours.class
       puts @deliveryHours.size
       puts @deliveryHours.first.class
       puts "YEAYYYYYAYSYAYSYASYASYAYS"

        puts Date.parse(@deliveryHours.first).strftime("%a %b %e %T %Y")
       render json: {slots: @deliveryHours}
       initiateCart
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
