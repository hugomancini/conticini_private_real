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

  def deleteOrder(orderID)
    uri = URI.parse("https://sandbox.urb-it.com/v3/checkouts/#{orderID}")
    request = Net::HTTP::Delete.new(uri)
    request["Authorization"] = "Bearer <JWT Authorization Header>"
    request["X-Api-Key"] = "<Urb-it API Key>"

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    response.code
    answer = response.body
    jsonAnswer = JSON.parse(answer)
    end

  def setDateTimeRecipient(checkoutId, json)
    uri = URI.parse("https://sandbox.urb-it.com/v3/checkouts/#{checkoutId}/delivery")
    request = Net::HTTP::Put.new(uri)
    request["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIzMDE4NzAxNS02MjUxLTQ5NDYtOTJiZC04MDVkNDAxMGVkY2YiLCJpYXQiOjE1NjkzMTI0NzUsInJvbGVzIjpbInJldGFpbGVyIl0sInN1YiI6IjkyMDEyNDE5LWQ3M2EtNDJmNS1hMTJjLWNkY2MyMDc0MGRlMyIsImlzcyI6InVyYml0LmNvbSIsIm5hbWUiOiJHXHUwMGUydGVhdXggZCdcdTAwYzltb3Rpb25zIFBhcmlzIiwiZXhwIjoxODg0NjcyNDc1fQ.P3YVPLgkbjJxD-A5-4-e_Cvx3xDmFDJMJIHB7NS5cos"
    request["X-Api-Key"] = "92012419-d73a-42f5-a12c-cdcc20740de3"
    request.body = json
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
    puts "THIS IS THE API ANSWER to SET DATE TIME RECIPIENT : "
    puts jsonAnswer
    render json: {answer: jsonAnswer}

  end

  def checkout(checkoutId)
    puts "INSIDE CHECKOUT with checkout ID = #{checkoutId}"
    uri = URI.parse("https://sandbox.urb-it.com/v2/checkouts/#{checkoutId}")
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIzMDE4NzAxNS02MjUxLTQ5NDYtOTJiZC04MDVkNDAxMGVkY2YiLCJpYXQiOjE1NjkzMTI0NzUsInJvbGVzIjpbInJldGFpbGVyIl0sInN1YiI6IjkyMDEyNDE5LWQ3M2EtNDJmNS1hMTJjLWNkY2MyMDc0MGRlMyIsImlzcyI6InVyYml0LmNvbSIsIm5hbWUiOiJHXHUwMGUydGVhdXggZCdcdTAwYzltb3Rpb25zIFBhcmlzIiwiZXhwIjoxODg0NjcyNDc1fQ.P3YVPLgkbjJxD-A5-4-e_Cvx3xDmFDJMJIHB7NS5cos"
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
    puts "------------------------------------------------"
    puts "THIS IS THE API ANSWER to checkout "
    puts jsonAnswer
    puts "Delivery TIme : "
    puts jsonAnswer["delivery_time"]
    puts "STATUS :"
    puts jsonAnswer["status"]
    puts "MESSAGE :"
    puts jsonAnswer["message"]
    puts "RECIPIENT :"
    puts jsonAnswer["recipient"]

    @checkoutHash = {
      "delivery_time" => "2019-10-03T19:00:00Z",
      "message" => "Door code: 1234",
      "recipient" => {
        "first_name" => "Test",
        "last_name" => "Testsson",
        "address_1" => "3 rue Jean Robert",
        "address_2" => "",
        "city" => "Paris",
        "postcode" => "75018",
        "phone_number" => "+331612345678",
        "email" => "test@grr.la"
      }
    }
    @checkoutJson = @checkoutHash.to_json
    setDateTimeRecipient(checkoutId, @checkoutJson)
  end

  def initiateCheckOut(cartId)
    puts "initiating checkout with #{cartId}"
    @hash2 = { "cart_reference" => cartId }
    @json2 = @hash2.to_json
    puts "THIS IS THE JSON CART REFERENCE : "
    puts @json2
    uri = URI.parse("https://sandbox.urb-it.com/v3/checkouts/")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIzMDE4NzAxNS02MjUxLTQ5NDYtOTJiZC04MDVkNDAxMGVkY2YiLCJpYXQiOjE1NjkzMTI0NzUsInJvbGVzIjpbInJldGFpbGVyIl0sInN1YiI6IjkyMDEyNDE5LWQ3M2EtNDJmNS1hMTJjLWNkY2MyMDc0MGRlMyIsImlzcyI6InVyYml0LmNvbSIsIm5hbWUiOiJHXHUwMGUydGVhdXggZCdcdTAwYzltb3Rpb25zIFBhcmlzIiwiZXhwIjoxODg0NjcyNDc1fQ.P3YVPLgkbjJxD-A5-4-e_Cvx3xDmFDJMJIHB7NS5cos"
    request["X-Api-Key"] = "92012419-d73a-42f5-a12c-cdcc20740de3"
    request.body = @json2
    req_options = {
      use_ssl: uri.scheme == "https",
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    response.code
    answer = response.body
    jsonAnswer = JSON.parse(answer)
    puts "------------------------------------------------"
    puts "THIS IS THE API ANSWER to initiateCheckOut : "
    puts jsonAnswer
    puts jsonAnswer.class
    @checkoutId =jsonAnswer["id"]
    puts "THIS IS THE CHECKOUT ID :" + @checkoutId
    checkout(@checkoutId)

  end

  def initiateCart
    getCartJson
    puts "INITIAITIEI CAAARRTT"
    uri = URI.parse("https://sandbox.urb-it.com/v2/carts")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIzMDE4NzAxNS02MjUxLTQ5NDYtOTJiZC04MDVkNDAxMGVkY2YiLCJpYXQiOjE1NjkzMTI0NzUsInJvbGVzIjpbInJldGFpbGVyIl0sInN1YiI6IjkyMDEyNDE5LWQ3M2EtNDJmNS1hMTJjLWNkY2MyMDc0MGRlMyIsImlzcyI6InVyYml0LmNvbSIsIm5hbWUiOiJHXHUwMGUydGVhdXggZCdcdTAwYzltb3Rpb25zIFBhcmlzIiwiZXhwIjoxODg0NjcyNDc1fQ.P3YVPLgkbjJxD-A5-4-e_Cvx3xDmFDJMJIHB7NS5cos"
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
    puts "------------------------------------------------"
    puts "THIS IS THE API ANSWER to initiate CART: "
    puts jsonAnswer
    @cartId = jsonAnswer["id"]
    puts "Cart is is :" + @cartId
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
        initiateCart
      else
    # if not, then we put an error message
       puts "Does #{params[:postcode]} can be delivered ? Answer is : #{@answer}"
       render json: {answer: @answer}
      end
  end

      def testJS
        @answer = "Hey Yoooooooo I am in da JS biatch"
        puts @answer
        render json: {answer: @answer}
      end



  private



  def connectApi
    shop_url = "https://6620956a37653def370f1cb21fb82e67:f47a2189cb3f4983d295d2867accaec2@hugo-mancini.myshopify.com"
    ShopifyAPI::Base.site = shop_url
    ShopifyAPI::Base.api_version = '2019-07'
  end

end
