#doc url: http://www.ioncannon.net/programming/91/using-ruby-and-httparty-to-consume-web-services-the-easy-way/

require 'rubygems'
require 'httparty'
  
 class BestBuy
   include HTTParty
   base_uri 'api.remix.bestbuy.com'
   default_params :apiKey => 'put your key here'
  
   def self.get_all_stores
     get("/v1/stores")
   end
  
   def self.get_stores_by_zip(zip)
     get("/v1/stores(postalCode=#{zip})")
   end
  
   def self.get_stores_by_zip_and_distance(zip, distance)
     get("/v1/stores(area(#{zip},#{distance}))")
   end
  
   def self.get_product_by_sku(sku)
     get("/v1/products/#{sku}.xml")
   end
  
   def self.get_products(filter)
     response = get(URI.escape("/v1/products(#{filter})"))
     response["products"]["product"]
   end
  
   def self.method_missing(method_id, *args)
     if match = /get_products_by_([_a-zA-Z]\w*)/.match(method_id.to_s)
       attribute_names = match.captures.last.split('_and_')
  
       request = ""
       attribute_names.each_with_index { |name, idx| request = request + name + "=" + args[idx] + (attribute_names.length-1 == idx ? "" : "&") }
  
       get_products(request)
     else
       super
     end
   end
 end