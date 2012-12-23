#Example taken from url http://www.ioncannon.net/programming/91/using-ruby-and-httparty-to-consume-web-services-the-easy-way/

require 'pp'
load 'BestBuyApi.rb'

pp BestBuy.get_stores_by_zip_and_distance(40299, 10)
pp BestBuy.get_product_by_sku(8880044)
#pp BestBuy.get_products_by_manufacturer('canon')
#pp BestBuy.get_products("manufacturer='canon'&salePrice<33")
#pp BestBuy.get_products_by_manufacturer_and_department('canon','video')
#pp BestBuy.get_products_by_manufacturer_and_department('canon','accessories')

#products = BestBuy.get_products_by_manufacturer_and_department('canon','accessories')
#products.each do |product|
#print "————————————————\n"
#print product["name"] + "\n"
#print product["longDescription"] + "\n"
#end