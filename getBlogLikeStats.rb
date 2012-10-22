#!/usr/bin/env ruby
# http://bobbelderbos.com/2012/01/ruby-script-facebook-like-stats-blog/
require 'net/https'
require 'rexml/document'
require 'json'; 

urlXml = 'http://bobbelderbos.com/sitemap.xml'
url = 'https://graph.facebook.com/?ids='
likes = Hash.new;

xml_data = Net::HTTP.get_response(URI.parse(urlXml)).body
doc = REXML::Document.new(xml_data)

doc.elements.each('urlset/url/loc')  { |element| url += element.text + "," }

uri = URI.parse(url[0..-2])
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
request = Net::HTTP::Get.new(uri.path + "?" + uri.query)
response = http.request(request)
data = response.body
result = JSON.parse(data)

result.each { |url| likes[url[1]['id']] = url[1]['shares'] }

likes.each do|url,numLikes|
  puts "#{url}: #{numLikes}"
end
